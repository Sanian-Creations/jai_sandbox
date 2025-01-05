main :: () {
	// Userdata stored with every file read asynchronously, so you can access it again after
	// waiting for the async file read to complete.
	My_FileAsync_UserData :: struct {
		file_name: string;
	}

	// Userdata passed when visiting all files, I use it as an accumulator to put all filenames
	// into the async read queue, and count how many we passed.
	My_VisitFiles_UserData :: struct {
		queue: *FA.Queue(My_FileAsync_UserData);
		file_count: int;
	}

	visit_data: My_VisitFiles_UserData;

	{
		// Odd language quirk here, cannot write `visit_data.queue=, err := blah()` because
		// `var=` must be a single identifier, not `var.field=`
		using visit_data;
		queue=, err := FA.initialize_queue(My_FileAsync_UserData);
		assert(err.code == .Success);
	}
	defer FA.destroy_queue(visit_data.queue);

	visit_proc :: (info: *FU.File_Visit_Info, visit_data: *My_VisitFiles_UserData) {
		/* (beta-1-091)
		File_Visit_Info ::
			short_name:             string; // filename
			full_name:              string; // path passed to visit_files + intermediate dirs +
			                                // filename
			modification_time:      Apollo_Time;
			had_error:              bool; // Whether there was an error when we tried to get all
			                              // necessary information about the file (eg. due to
			                              // insuficient perimssions).
			is_symlink:             bool;
			is_directory:           bool;
			descend_into_directory: bool; // Can be modified by the visit procedure to indicate
			                              // that we shouldn't go into this directory.
		*/

		assert(!info.had_error);

		if !Str.ends_with(info.short_name, ".jai") return;
		if info.is_symlink  return;
		if info.is_directory {
			print("cannot go into dir '%' because dirs are not supported yet\n", info.short_name);
			info.descend_into_directory = false;
			return;
		}

		// @Note: Assume both short_name and full_name get invalidated after all files are visited.
		//        Make a copy if we want to use them.
		visit_data.file_count += 1;
		FA.read_entire_file(
			visit_data.queue,
			info.full_name,
			user_data = .{ file_name = copy_string(info.short_name) }
		); // @Leak filename
	}


	// - synchronously visit all files, then
	// - add those files to the async queue that READS them asynchronously.
	visit_ok := FU.visit_files(dir_name = ".",
		user_data   = *visit_data,
		proc        = visit_proc,
		recursive                 = false,
		visit_files               = true,
		visit_directories         = false,
		visit_symlinks            = false,
		follow_directory_symlinks = false
	);

	assert(visit_ok);

	for 1..visit_data.file_count {
		// (queue: *Queue($T), check_only := false) -> T, data: [] u8, Error
		// T is the userdata, in this case the filename
		user_data, file_content, err := FA.wait_for_completion(visit_data.queue);
		assert(!err.code);

		defer array_free(file_content);
		defer free(user_data.file_name);
		// We free the filename here, but maybe we want to keep it later

		print("'%' has % characters\n", user_data.file_name, file_content.count);
	}
}

#import "Basic";
FA :: #import "File_Async";
FU :: #import "File_Utilities";
Str :: #import "String";
