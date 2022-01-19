function [spikeTimeIdx, clusterIdx, templates, spikeTemplateIdx] = parseSpikeNPY(ROOTPATH, fs)
    spikeTimeIdx = readNPY([ROOTPATH, '\spike_times.npy']);
    clusterIdx = readNPY([ROOTPATH, '\spike_clusters.npy']);
    templates = readNPY([ROOTPATH, '\templates.npy']);
    spikeTemplateIdx = readNPY([ROOTPATH, '\spike_templates.npy']);

%     spikeTimes = double(spikeTimeIdx - 1) / fs;

    %% Plot Templates
%     nChannels = size(templates, 3);
%     nTemplates = size(templates, 1);
% 
%     for cIndex = 1:nChannels
%         figure;
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