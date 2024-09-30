function codegen(model_path, output_dir, step_size, solver_name, additional_paths, c_lang_standard)
    current_dir = pwd();
    oC1 = onCleanup(@() cd(current_dir));
    temp_dir = fullfile(tempdir, tempname);
    mkdir(temp_dir);
    oC2 = onCleanup(@() rmdir(temp_dir, 's'));
    cd(temp_dir)
    orderedCleanupObj = onCleanup(@()cellfun(@delete, {oC1, oC2}));

    for i = 1:length(additional_paths)
        addpath(additional_paths{i});
    end

    [~, model_name, ~] = fileparts(model_path);
    oC3 = onCleanup(@() close_system(model_name, 0));
    load_system(model_path);
    model_config = getActiveConfigSet(model_name);
    set_param(model_config, 'SystemTargetFile','ert.tlc');
    set_param(model_config, 'SupportContinuousTime','on');
    set_param(model_config, 'GenerateSampleERTMain','off');
    set_param(model_config, 'SolverType', 'Fixed-step');
    set_param(model_config, 'Solver', solver_name);
    set_param(model_config, 'FixedStep', num2str(step_size));
    set_param(model_config, 'TargetLang', 'C');
    set_param(model_config, 'TargetLangStandard', c_lang_standard);
    set_param(model_config, 'Toolchain', 'GNU gcc/g++ | gmake (64-bit Linux)');

    set_param(model_name,'DataTypeOverride','Off');
    id_length = max(length(model_name) + 15, 31);
    set_param(model_name, 'MaxIdLength', id_length);

    slbuild(model_name, 'GenerateCodeOnly', true);

    build_info = dir(fullfile(temp_dir, '**/buildInfo.mat'));
    build_info_dir_path = build_info.folder;

    packNGo(build_info_dir_path,'packType', 'flat', 'nestedZipFiles', false, ...
        'minimalHeaders', true, 'includeReport', false, 'fileName', model_name);

    resulting_zip_path = fullfile(temp_dir, strcat(model_name, '.zip'));
    unzip(resulting_zip_path, output_dir);
    delete(fullfile(output_dir, 'rt_main.c'));
    cd(current_dir);
end