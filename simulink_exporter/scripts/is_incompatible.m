function result = is_incompatible(model_path)
    model_info = Simulink.MDLInfo(model_path);
    result = isMATLABReleaseOlderThan(model_info.ReleaseName);
end