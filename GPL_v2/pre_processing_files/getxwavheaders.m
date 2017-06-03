function PARAMS=getxwavheaders(dir, fn)

m=0;
 k=1; 
    
  %PARAMS.ltsa.indir='/Users/tylerhelble/sio/colt/GlennMac/cepstrum_harp/testingcenter2/wavefiles';
  %PARAMS.ltsa.fname(k,:)='SOCAL35M_sitM_091110_134115.x.wav';
  
  PARAMS.ltsa.indir=dir;
  PARAMS.ltsa.fname(k,:)=fn;

  fnsz = size(PARAMS.ltsa.fname);        % number of data files in directory
PARAMS.ltsa.nxwav = fnsz(1);           % number of xwav files
PARAMS.ltsahd.fname = char(zeros(PARAMS.ltsa.nxwav,40));         % make empty matrix - filenames need to be 40 char or less


       
                 % do the following for xwavs
        fid = fopen(fullfile(PARAMS.ltsa.indir,PARAMS.ltsa.fname(k,:)),'r');
                
        fseek(fid,22,'bof');
        PARAMS.ltsa.nch = fread(fid,1,'uint16');         % Number of Channels
        
        fseek(fid,34,'bof');
        PARAMS.ltsa.nBits = fread(fid,1,'uint16');       % # of Bits per Sample : 8bit = 8, 16bit = 16, etc
        if PARAMS.ltsa.nBits == 16
            PARAMS.ltsa.dbtype = 'int16';
        elseif PARAMS.ltsa.nBits == 32
            PARAMS.ltsa.dbtype = 'int32';
        else
            disp_msg('PARAMS.ltsa.nBits = ')
            disp_msg(PARAMS.ltsa.nBits)
            disp_msg('not supported')
            return
        end
        
        fseek(fid,80,'bof');
        nrf = fread(fid,1,'uint16');         % Number of RawFiles in XWAV file (80 bytes from bof)

        fseek(fid,100,'bof');
        for r = 1:nrf                           % loop over the number of raw files in this xwav file
            m = m + 1;                                              % count total number of raw files
            PARAMS.ltsahd.rfileid(m) = r;                           % raw file id / number in this xwav file
            PARAMS.ltsahd.year(m) = fread(fid,1,'uchar');          % Year
            PARAMS.ltsahd.month(m) = fread(fid,1,'uchar');         % Month
            PARAMS.ltsahd.day(m) = fread(fid,1,'uchar');           % Day
            PARAMS.ltsahd.hour(m) = fread(fid,1,'uchar');          % Hour
            PARAMS.ltsahd.minute(m) = fread(fid,1,'uchar');        % Minute
            PARAMS.ltsahd.secs(m) = fread(fid,1,'uchar');          % Seconds
            PARAMS.ltsahd.ticks(m) = fread(fid,1,'uint16');        % Milliseconds
            PARAMS.ltsahd.byte_loc(m) = fread(fid,1,'uint32');     % Byte location in xwav file of RawFile start
            PARAMS.ltsahd.byte_length(m) = fread(fid,1,'uint32');    % Byte length of RawFile in xwav file
            PARAMS.ltsahd.write_length(m) = fread(fid,1,'uint32'); % # of blocks in RawFile length (default = 60000)
            PARAMS.ltsahd.sample_rate(m) = fread(fid,1,'uint32');  % sample rate of this RawFile
            PARAMS.ltsahd.gain(m) = fread(fid,1,'uint8');          % gain (1 = no change)
            PARAMS.ltsahd.padding = fread(fid,7,'uchar');    % Padding to make it 32 bytes...misc info can be added here
            PARAMS.ltsahd.fname(m,1:fnsz(2)) = PARAMS.ltsa.fname(k,:);        % xwav file name for this raw file header

            PARAMS.ltsahd.dnumStart(m) = datenum([PARAMS.ltsahd.year(m) PARAMS.ltsahd.month(m)...
                PARAMS.ltsahd.day(m) PARAMS.ltsahd.hour(m) PARAMS.ltsahd.minute(m) ...
                PARAMS.ltsahd.secs(m)+(PARAMS.ltsahd.ticks(m)/1000)]);

        end
        fclose(fid);


PARAMS.ltsa.nrftot = m;     % total number of raw files