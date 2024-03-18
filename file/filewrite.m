function filewrite(filepath, A)
    % Example:
    %     % Alter function signatures file by script
    %     signatures = jsondecode(fileread("functionSignatures.json"));
    %     signatures.filewrite.description = "Write text to file";
    %     json_text = jsonencode(signatures, "PrettyPrint", true);
    %     filewrite("functionSignatures.json", json_text);

    fid = fopen(filepath, 'w');
    fprintf(fid, '%s', A);
    fclose(fid);
    return;
end