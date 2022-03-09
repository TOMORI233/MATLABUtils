function [spikeIdx, clusterIdx, templates, spikeTemplateIdx] = parseNPY(ROOTPATH)
    % 获取kilosort结果
    spikeIdx = readNPY([ROOTPATH, '\spike_times.npy']);
    clusterIdx = readNPY([ROOTPATH, '\spike_clusters.npy']);
    templates = readNPY([ROOTPATH, '\templates.npy']);
    spikeTemplateIdx = readNPY([ROOTPATH, '\spike_templates.npy']);

    %% Plot Templates
%     nChannels = size(templates, 3);
%     nTemplates = size(templates, 1);
% 
%     for cIndex = 1:nChannels
%         Fig = figure;
%         maximizeFig(Fig);
% 
%         for tIndex = 1:nTemplates
%             subplot(8, ceil(nTemplates / 8), tIndex);
%             plot(templates(tIndex, :, cIndex));
%             xticklabels('');
%             yticklabels('');
%             title(['C' num2str(cIndex) 'T' num2str(tIndex)]);
%             drawnow;
%         end
% 
%     end
    
    return;
end