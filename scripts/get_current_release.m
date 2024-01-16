function releaseStr = get_current_release()
    fullVersionStr = version;

    releaseStr = regexp(fullVersionStr, 'R\d{4}[ab]', 'match');
    if ~isempty(releaseStr)
        releaseStr = releaseStr{1};
    end
end