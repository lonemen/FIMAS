function [ status, message ] = data_export( obj, index )
%DATA_EXPORT export selected data from a session
%  only export selected data for future import

%% function complete

status=false;
try
    [filename,pathname,~]=uiputfile({'*.edf','exported data file (*.edf)';...
        '*.*','All Files (*.*)'},...
        'Select Exported Data Analysis File',obj.path.export);
    if pathname~=0     %if files selected
        filename=cat(2,pathname,filename);
        dataitem=obj.data(index);
        % clear handles
        for dataidx=1:numel(dataitem)
            dataitem(dataidx).datainfo.panel=[];
            for roiidx=2:numel(dataitem(dataidx).roi)
                dataitem(dataidx).roi(roiidx).panel=[];
                dataitem(dataidx).roi(roiidx).handle=[];
            end
        end
        %to cope with large file size
        save(filename,'dataitem','-mat','-v7.3');
        %update saved path
        obj.path.export=pathname;
        message=sprintf('data item %g exported\n',index);
        status=true;
    else
        %action cancelled
        message=sprintf('%s\n','file export action cancelled');
    end
catch exception%error handle
    message=sprintf('%s\n',exception.message);
end