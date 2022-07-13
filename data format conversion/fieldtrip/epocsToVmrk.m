function [vmrk,rez] = epocsToVmrk(data,fs)
    eventString = {'Stimulus','Response';'S','R'};
   
    stimEpocs = data.epocs.PC0_;
    pushEpocs.data = [];
    pushEpocs.onset = [];

    rez.stim.data = stimEpocs.data;
    rez.stim.time = ceil(stimEpocs.onset*fs);
    rez.push.data = pushEpocs.data;
    rez.push.time = ceil(pushEpocs.onset*fs);
    % column: 1-sample number | 2-mark | 3-event type
    eventBuffer = [rez.stim.time rez.stim.data  ones(length(rez.stim.time),1);...
                   rez.push.time rez.push.data  ones(length(rez.push.time),1)*2];
    
    events = sortrows(eventBuffer,1);
    vmrk = [];
    for i = 1 : size(events,1)
        vmrk = [vmrk 'Mk' num2str(i+1) '=' eventString{1,events(i,3)} ',S' num2str(events(i,2)) ',' num2str(events(i,1)) ',1,0\r\n'];
    end
end
    