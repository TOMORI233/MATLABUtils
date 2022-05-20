function vhdr = channelsToVhdr(channelNum,sampleRate)
vhdr = [];
for i = 1 : channelNum
    vhdr = [vhdr 'Ch' num2str(i) '=' num2str(i) ',,0.1,µV\r\n'];
end

vhdr = [vhdr '\r\n[Comment]\r\n\r\n' ...
    'A m p l i f i e r  S e t u p\r\n'...
    '============================\r\n'...
    'Number of channels: ' num2str(channelNum) '\r\n'...
'Sampling Rate [Hz]: ' num2str(sampleRate) '\r\n'...
'Sampling Interval [µS]:' num2str(1e6/sampleRate) '\r\n\r\n'...
'Channels\r\n'...
'--------\r\n'...
'#     Name      Phys. Chn.    Resolution / Unit   Low Cutoff [s]   High Cutoff [Hz]   Notch [Hz]\r\n'...
];

for i = 1 : channelNum
    vhdr = [vhdr num2str(i) '     ' num2str(i) '           ' num2str(i) '                0.1 µV             10             1000              Off\r\n'];
end


vhdr = [vhdr '\r\n'...
    'S o f t w a r e  F i l t e r s\r\n'...
    '==============================\r\n'...
    '#     Low Cutoff [s]   High Cutoff [Hz]   Notch [Hz]\r\n'];

for i = 1 : channelNum
    vhdr = [vhdr num2str(i) '      10               200                Off\r\n'];
end

vhdr = [vhdr '\r\n'...
    'No impedance values available at 11:20:32!\r\n'];
end