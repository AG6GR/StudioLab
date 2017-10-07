
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (C) OMG Plc 2009.
% All rights reserved.  This software is protected by copyright
% law and international treaties.  No part of this software / document
% may be reproduced or distributed in any form or by any means,
% whether transiently or incidentally to some other use of this software,
% without the written permission of the copyright owner.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part of the Vicon DataStream SDK for MATLAB.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Program options
TransmitMulticast = false;
EnableHapticFeedbackTest = false;
HapticOnList = {'ViconAP_001';'ViconAP_002'};
bReadCentroids = false;

% OSC options
PREFIX = '/blender';

% A dialog to stop the loop
MessageBox = msgbox( 'Stop DataStream Client', 'Vicon DataStream SDK' );
%
List_of_Objects = {'o_axe', 'o_beast','o_skull','o_spear','o_sword','Wand'};
%  2

% Load the SDK
fprintf( 'Loading SDK...' );
Client.LoadViconDataStreamSDK();
fprintf( 'done\n' );

% Program options
HostName = '169.254.215.174:801';
u2 = udp('192.168.1.3',3330);
fopen(u2);

% Make a new client
MyClient = Client();

% Connect to a server
fprintf( 'Connecting to %s ...', HostName );
while ~MyClient.IsConnected().Connected
    % Direct connection
    MyClient.Connect( HostName );
    
    % Multicast connection
    % MyClient.ConnectToMulticast( HostName, '224.0.0.0' );
    
    fprintf( '.' );
end
fprintf( '\n' );

% Enable some different data types
MyClient.EnableSegmentData();
MyClient.EnableMarkerData();
MyClient.EnableUnlabeledMarkerData();
MyClient.EnableDeviceData();
if bReadCentroids
    MyClient.EnableCentroidData();
end

fprintf( 'Segment Data Enabled: %s\n',          AdaptBool( MyClient.IsSegmentDataEnabled().Enabled ) );
fprintf( 'Marker Data Enabled: %s\n',           AdaptBool( MyClient.IsMarkerDataEnabled().Enabled ) );
fprintf( 'Unlabeled Marker Data Enabled: %s\n', AdaptBool( MyClient.IsUnlabeledMarkerDataEnabled().Enabled ) );
fprintf( 'Device Data Enabled: %s\n',           AdaptBool( MyClient.IsDeviceDataEnabled().Enabled ) );
fprintf( 'Centroid Data Enabled: %s\n',         AdaptBool( MyClient.IsCentroidDataEnabled().Enabled ) );

% Set the streaming mode
MyClient.SetStreamMode( StreamMode.ClientPull );
% MyClient.SetStreamMode( StreamMode.ClientPullPreFetch );
% MyClient.SetStreamMode( StreamMode.ServerPush );

% Set the global up axis
MyClient.SetAxisMapping( Direction.Forward, ...
    Direction.Left,    ...
    Direction.Up );    % Z-up
% MyClient.SetAxisMapping( Direction.Forward, ...
%                          Direction.Up,      ...
%                          Direction.Right ); % Y-up

Output_GetAxisMapping = MyClient.GetAxisMapping();
fprintf( 'Axis Mapping: X-%s Y-%s Z-%s\n', Output_GetAxisMapping.XAxis.ToString(), ...
    Output_GetAxisMapping.YAxis.ToString(), ...
    Output_GetAxisMapping.ZAxis.ToString() );


% Discover the version number
Output_GetVersion = MyClient.GetVersion();
fprintf( 'Version: %d.%d.%d\n', Output_GetVersion.Major, ...
    Output_GetVersion.Minor, ...
    Output_GetVersion.Point );

if TransmitMulticast
    MyClient.StartTransmittingMulticast( 'localhost', '224.0.0.0' );
end

Counter = 1;
% Loop until the message box is dismissed
while ishandle( MessageBox )
    drawnow;
    Counter = Counter + 1;
    
    % Get a frame
    fprintf( '\n\nWaiting for new frame...' );
    while MyClient.GetFrame().Result.Value ~= Result.Success
        fprintf( '.' );
    end% while
    fprintf( '\n' );
    
    % Get the frame number
    Output_GetFrameNumber = MyClient.GetFrameNumber();
    fprintf( 'Frame Number: %d\n', Output_GetFrameNumber.FrameNumber );
    
    % Get the frame rate
    Output_GetFrameRate = MyClient.GetFrameRate();
    fprintf( 'Frame rate: %g\n', Output_GetFrameRate.FrameRateHz );
    
    %     % Get the timecode
    %     Output_GetTimecode = MyClient.GetTimecode();
    %     fprintf( 'Timecode: %dh %dm %ds %df %dsf %s %d %d %d\n\n',    ...
    %         Output_GetTimecode.Hours,                  ...
    %         Output_GetTimecode.Minutes,                ...
    %         Output_GetTimecode.Seconds,                ...
    %         Output_GetTimecode.Frames,                 ...
    %         Output_GetTimecode.SubFrame,               ...
    %         AdaptBool( Output_GetTimecode.FieldFlag ), ...
    %         Output_GetTimecode.Standard.Value,         ...
    %         Output_GetTimecode.SubFramesPerFrame,      ...
    %         Output_GetTimecode.UserBits );
    
    % Get the latency
    fprintf( 'Latency: %gs\n', MyClient.GetLatencyTotal().Total );
    
    %     for LatencySampleIndex = 1:MyClient.GetLatencySampleCount().Count
    %         SampleName  = MyClient.GetLatencySampleName( LatencySampleIndex ).Name;
    %         SampleValue = MyClient.GetLatencySampleValue( SampleName ).Value;
    %
    %         fprintf( '  %s %gs\n', SampleName, SampleValue );
    %     end% for
    fprintf( '\n' );
    
    % Count the number of subjects
    SubjectCount = MyClient.GetSubjectCount().SubjectCount;
    fprintf( 'Subjects (%d):\n', SubjectCount );
    for SubjectIndex = 1:SubjectCount
                fprintf( '  Subject #%d\n', SubjectIndex - 1 );
        
        % Get the subject name
        SubjectName = MyClient.GetSubjectName( SubjectIndex ).SubjectName;
        fprintf( '    Name %d: %s\n', SubjectIndex, SubjectName );
        
        for obj_index = 1:length(List_of_Objects)
            object_Name = List_of_Objects(obj_index);
            
            
            if strcmp(SubjectName,object_Name)
                
                % Get the root segment
                %             RootSegment = MyClient.GetSubjectRootSegmentName( SubjectName ).SegmentName;
                %             fprintf( '    Root Segment: %s\n', RootSegment );
                
                % Count the number of segments
                SegmentCount = MyClient.GetSegmentCount( SubjectName ).SegmentCount;
                fprintf( '    Segments (%d):\n', SegmentCount );
                
                for SegmentIndex = 1:SegmentCount
                    fprintf( '      Segment #%d\n', SegmentIndex - 1 );
                    
                    % Get the segment name
                    SegmentName = MyClient.GetSegmentName( SubjectName, SegmentIndex ).SegmentName;
                    fprintf( '        Name: %s\n', SegmentName );
                    
                    if strcmp(SegmentName,object_Name)
                        
                        % Get the global segment translation
                        Output_GetSegmentGlobalTranslation = MyClient.GetSegmentGlobalTranslation( SubjectName, SegmentName );
                                            fprintf( '        Global Translation: (%g, %g, %g) %s\n',               ...
                                                Output_GetSegmentGlobalTranslation.Translation( 1 ), ...
                                                Output_GetSegmentGlobalTranslation.Translation( 2 ), ...
                                                Output_GetSegmentGlobalTranslation.Translation( 3 ), ...
                                                AdaptBool( Output_GetSegmentGlobalTranslation.Occluded ) );
                        x = Output_GetSegmentGlobalTranslation.Translation(1);
                        y = Output_GetSegmentGlobalTranslation.Translation(2);
                        z = Output_GetSegmentGlobalTranslation.Translation(3);
                        
                        % Get the global segment rotation in EulerXYZ co-ordinates
                        Output_GetSegmentGlobalRotationEulerXYZ = MyClient.GetSegmentGlobalRotationEulerXYZ( SubjectName, SegmentName );
                                            fprintf( '        Global Rotation EulerXYZ: (%g, %g, %g) %s\n',                 ...
                                                Output_GetSegmentGlobalRotationEulerXYZ.Rotation( 1 ),       ...
                                                Output_GetSegmentGlobalRotationEulerXYZ.Rotation( 2 ),       ...
                                                Output_GetSegmentGlobalRotationEulerXYZ.Rotation( 3 ),       ...
                                                AdaptBool( Output_GetSegmentGlobalRotationEulerXYZ.Occluded ) );
                        angle_1 = Output_GetSegmentGlobalRotationEulerXYZ.Rotation(1);
                        angle_2 = Output_GetSegmentGlobalRotationEulerXYZ.Rotation(2);
                        angle_3 = Output_GetSegmentGlobalRotationEulerXYZ.Rotation(3);
                        oscsend(u2,strcat(PREFIX, '/x'),'f',x/1000);
                        oscsend(u2,strcat(PREFIX, '/y'),'f',y/1000);
                        oscsend(u2,strcat(PREFIX, '/z'),'f',z/1000);
                        oscsend(u2,strcat(PREFIX, '/rotation/angle_1'),'f',angle_1);
                        oscsend(u2,strcat(PREFIX, '/rotation/angle_2'),'f',angle_2);
                        oscsend(u2,strcat(PREFIX, '/rotation/angle_3'),'f',angle_3);
                        obj_index
                        [x,y,z]
                        [angle_1,angle_2,angle_3]
                        %
                    end % end of if
                    
                end% S  egmentIndex
                
                % Count the number of markers
                MarkerCount = MyClient.GetMarkerCount( SubjectName ).MarkerCount;
                fprintf( '    Markers - %d \n', MarkerCount );
                
            end % end of if
            
        end % end of obj_index
        
    end% SubjectIndex
    
end% while true

if TransmitMulticast
    MyClient.StopTransmittingMulticast();
end

% Disconnect and dispose
MyClient.Disconnect();
fclose(u2);

% Unload the SDK
fprintf( 'Unloading SDK...' );
Client.UnloadViconDataStreamSDK();
fprintf( 'done\n' );
