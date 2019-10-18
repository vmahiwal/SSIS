
	--ExecutionMessageTypes fixed members
    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionMessageTypes]
                    WHERE   [ExecutionMessageTypeId] = 1 )
        BEGIN
            INSERT  [SystemLog].[ExecutionMessageTypes]
                    ( [ExecutionMessageTypeId] ,
                      [ExecutionMessageTypeName] ,
                      [ExecutionMessageTypeDescription],
					  [SSISDBMessageType]
                    )
            VALUES  ( 1 ,
                      N'Error' ,
                      N'The message logged contains the error derscription.',
					  120
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionMessageTypes]
                    WHERE   [ExecutionMessageTypeId] = 2 )
        BEGIN
            INSERT  [SystemLog].[ExecutionMessageTypes]
                    ( [ExecutionMessageTypeId] ,
                      [ExecutionMessageTypeName] ,
                      [ExecutionMessageTypeDescription],
					  [SSISDBMessageType]
                    )
            VALUES  ( 2 ,
                      N'Warning' ,
                      N'The message logged is a warning.',
					  110
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionMessageTypes]
                    WHERE   [ExecutionMessageTypeId] = 3 )
        BEGIN
            INSERT  [SystemLog].[ExecutionMessageTypes]
                    ( [ExecutionMessageTypeId] ,
                      [ExecutionMessageTypeName] ,
                      [ExecutionMessageTypeDescription],
					  [SSISDBMessageType]
                    )
            VALUES  ( 3 ,
                      N'Information' ,
                      N'The message logged is informative only.',
					  70
                    );
        END;


--ExecutionStatus fixed members
    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 0 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 0 ,
                      N'Unkmown' ,
                      N''
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 1 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 1 ,
                      N'Execution created' ,
                      N'The SSIS execution has been initiated.'
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 2 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 2 ,
                      N'Running' ,
                      N'The SSIS execution is currently running.'
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 3 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 3 ,
                      N'Cancelled' ,
                      N'The SSIS execution has been cancelled.'
                    );
        END;


    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 4 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 4 ,
                      N'Failed' ,
                      N'The SSIS execution encountered errors.'
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 5 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 5 ,
                      N'Pending' ,
                      N'The SSIS execution is pending.'
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 6 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 6 ,
                      N'Ended unexpectedly' ,
                      N'The SSIS execution could not finish.'
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 7 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 7 ,
                      N'Succeeded' ,
                      N'The SSIS execution completed successfully.'
                    );
        END;

    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 8 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 8 ,
                      N'Stopping' ,
                      N'The SSIS execution is currently stopping.'
                    );
        END;
    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[ExecutionStatus]
                    WHERE   [ExecutionStatusId] = 9 )
        BEGIN
            INSERT  [SystemLog].[ExecutionStatus]
                    ( [ExecutionStatusId] ,
                      [ExecutionStatusName] ,
                      [ExecutionStatusDescription]
                    )
            VALUES  ( 9 ,
                      N'Completed' ,
                      N'The SSIS execution has completed.'
                    );
        END;

   --SystmeLog.LoadApplication unkmown member
    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[LoadApplications] AS [la]
                    WHERE   [la].[LoadApplicationId] = 0 )
        BEGIN
            SET IDENTITY_INSERT [SystemLog].[LoadApplications] ON;
            INSERT  INTO [SystemLog].[LoadApplications]
                    ( [LoadApplicationId] ,
                      [ApplicationName] ,
                      [ApplicationDescription]
                    )
            VALUES  ( 0 ,
                      N'Unknown',
                      N'Unknown load application'
		            );
            SET IDENTITY_INSERT [SystemLog].[LoadApplications] OFF;
        END;

		--SystmeLog.LoadApplication SSIS CookBook application
    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[LoadApplications] AS [la]
                    WHERE   [la].[LoadApplicationId] = 1 )
        BEGIN
            SET IDENTITY_INSERT [SystemLog].[LoadApplications] ON;
            INSERT  INTO [SystemLog].[LoadApplications]
                    ( [LoadApplicationId] ,
                      [ApplicationName] ,
                      [ApplicationDescription]
                    )
            VALUES  ( 1 ,
                      N'SSIS CookBook',
                      N'SSIS CookBook sample application'
		            );
            SET IDENTITY_INSERT [SystemLog].[LoadApplications] OFF;
        END;

	--SystmeLog.Loads unkmown member
    IF NOT EXISTS ( SELECT TOP 1
                            1
                    FROM    [SystemLog].[Loads] AS [l]
                    WHERE   [l].[LoadId] =-1 )
        BEGIN
            SET IDENTITY_INSERT [SystemLog].[Loads] ON;
            INSERT  INTO [SystemLog].[Loads]
                    ( [LoadId] ,
                      [LoadStartDateTime] ,
                      [LoadEndDateTime] ,
                      [LoadStatusId],
					  [LoadApplicationId]
                    )
            VALUES  ( -1 ,
                      CAST('1900-01-01' AS DATETIME) ,
                      CAST('1900-01-01' AS DATETIME) ,
                      0,
					  0
		            );
            SET IDENTITY_INSERT [SystemLog].[Loads] OFF;
        END;