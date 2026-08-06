%% RunPaper1Analysis
%
% Reproduces the principal numerical analyses reported in Paper 1.
%
% The pipeline:
%   1. Loads analysis-ready structural, functional, behavioral, and
%      movement data.
%   2. Realigns subject-specific connectome harmonics.
%   3. Computes harmonic and regional descriptors.
%   4. Identifies reproducible spectral families.
%   5. Runs harmonic-wise and family-wise behavioral predictions.
%   6. Computes task-dependent harmonic dynamics.
%   7. Assesses movement effects, task contrasts, and predictive
%      architecture.
%
% Main analyses use the normalized graph Laplacian derived from normalized
% fiber density at scale 3 of the Lausanne atlas (216 cortical regions).


%% 1. Configuration and setup

% Gets the root directory location
CurrentFile = mfilename('fullpath');

if isempty(CurrentFile)
    error('Paper1:RootNotFound', ...
        ['The repository root could not be determined. Run the complete ' ...
         'RunPaper1Analysis.m script rather than executing this section ' ...
         'from the Command Window.']);
end

RootDir = fileparts(fileparts(CurrentFile));

% Directories containing all the required functions for the script to run
% as well as the required inputs
SourceDir = fullfile(RootDir,'src');
ExternalDir = fullfile(RootDir,'external');
InputDataDir = fullfile(RootDir,'data','inputs');
AnalysisDir = fullfile(RootDir,'analysis');
addpath(AnalysisDir);

if ~isfolder(SourceDir)
    error('Paper1:MissingSourceDirectory', ...
        'Source directory not found: %s',SourceDir);
end

if ~isfolder(ExternalDir)
    error('Paper1:MissingExternalDirectory', ...
        'External dependency directory not found: %s',ExternalDir);
end

if ~isfolder(InputDataDir)
    error('Paper1:MissingInputDirectory', ...
        'Input-data directory not found: %s',InputDataDir);
end

% Adds source code and required third-party functions.
addpath(genpath(SourceDir));
addpath(genpath(ExternalDir));

% Prepares analysis configuration
Cfg = GSPTB_Paper1Config();

% Data directory where we will save the outputs
DataDirSave = fullfile(RootDir,'data','intermediate','test');

if ~isfolder(DataDirSave)
    mkdir(DataDirSave);
end

% Full-cohort reference checkpoints used as prerequisites for independent
% testing of each analysis section
DataDirLoad = fullfile(RootDir,'data','intermediate','full');

if ~isfolder(DataDirLoad)
    error('Paper1:MissingFullCheckpointDirectory', ...
        'Full-cohort checkpoint directory not found: %s',DataDirLoad);
end

% Stage-specific subject selections, picked to ensure all steps can be run
% within a reasonable time. 
% Estimated times for running are specified for each section, for the 
% suggested numbers of subjects.

% Less than 10 seconds for the whole population
SubjectIndices.Realignment = 1:875;

% Around 82 seconds per subject --> 13.67 minutes for 10 subjects
SubjectIndices.Descriptors = 1:10;

% Around 2 minutes for the full population
SubjectIndices.StabilityNull = 1:875;

% Around one minute for 20 subjects
SubjectIndices.RawSCAnalysis = 1:20;

% Around 85 seconds for 50 subjects
SubjectIndices.SurrogateSparsity = 1:50;

% Around 250 seconds (matrix generation) + 20 seconds (null distribution)
SubjectIndices.FamilyOrganization = 1:875;

% Around half an hour for one full harmonic-wise prediction curve, and
% around 6 minutes for family-wise prediction
SubjectIndices.BehaviorPrediction = 1:200;

% Around 20 seconds per subject --> 3 min 20 s for 10 subjects
SubjectIndices.DynamicAnalysis = 1:10;

% Around 110 seconds for the full subject population
SubjectIndices.MovementAnalysis = 1:875;

% Around up to 110 seconds (rerun movement stats on subject subset) + 35
% seconds (contrast analyses themselves) for the full subject population
SubjectIndices.TaskContrasts = 1:875;

% Around 8 min 50 s for 400 subjects
SubjectIndices.ArchitectureAnalysis = 1:400;

% Stage controls specifying which independent analyses are executed.
% Disabled stages are skipped. Each enabled section explicitly loads its
% own prerequisites from the full-cohort checkpoint directory.
Cfg.Run.Realignment = true;
Cfg.Run.Descriptors = true;
Cfg.Run.StabilityNull = true;
Cfg.Run.RawSCAnalysis = true;
Cfg.Run.SurrogateSparsity = true;
Cfg.Run.FamilyOrganization = true;
Cfg.Run.BehaviorPrediction = true;
Cfg.Run.DynamicAnalysis = true;
Cfg.Run.MovementAnalysis = true;
Cfg.Run.TaskContrasts = true;
Cfg.Run.ArchitectureAnalysis = true;



%% 2. Realignment of connectome harmonics

if Cfg.Run.Realignment

    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.Realignment;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);

    % Realignment per se
    [U_R,Lambda_R,RealignmentInfo] = GSPTB_RealignHarmonicCohort(Data.U,...
    Data.Lambda,Cfg.Harmonics.ReferenceSubject);

    % Saves the outputs
    RealignmentFile = fullfile(DataDirSave,'01_Realignment.mat');
    save(RealignmentFile,'U_R','Lambda_R','RealignmentInfo','-v7.3');
end



%% 3. Harmonic descriptors

if Cfg.Run.Descriptors

    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.Descriptors;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);
    
    % Loads the realigned harmonics and eigenvalues, samples the required
    % subjects
    load(fullfile(DataDirLoad,'01_Realignment.mat'),'U_R','Lambda_R');
    U_R = U_R(SubjectIndices.Descriptors);
    Lambda_R = Lambda_R(SubjectIndices.Descriptors);

    % Computes harmonic descriptors
    HarmonicDescriptors = GSPTB_ComputeCohortHarmonicDescriptors(U_R, ...
        Lambda_R,Data.Adj,Data.DegMat,Cfg.Harmonics.SparsityThreshold, ...
        Data.RegionDistances,Cfg.Harmonics.NormalizeAdjacency, ...
        Cfg.Harmonics.ModularityGamma);

    % Saves the outputs
    DescriptorsFile = fullfile(DataDirSave,'02_HarmonicDescriptors.mat');
    save(DescriptorsFile,'HarmonicDescriptors','-v7.3');
end



%% 4. Stability significance assessment

if Cfg.Run.StabilityNull

    % Loads the realigned harmonics, samples the required subjects
    load(fullfile(DataDirLoad,'01_Realignment.mat'),'U_R');
    U_R = U_R(SubjectIndices.StabilityNull);

    % Recomputes stability at the required number of subjects
    Stability = GSPTB_ComputeHarmonicStability(U_R);

    % Now assesses significance
    Stability_SignElements = GSPTB_ComputeHarmonicStabilityNull(Stability,...
        U_R,Cfg.Statistics.Stability.NumNulls,...
        Cfg.Statistics.Stability.AlphaPercent,size(Stability,1));

    StabilityFile = fullfile(DataDirSave,'03_StabilityAnalysis.mat');
    save(StabilityFile,'Stability_SignElements','-v7.3');
end



%% 5. Raw SC graph-theoretical metrics and links to spectral participation

if Cfg.Run.RawSCAnalysis

    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.RawSCAnalysis;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);

    % Loads spectral participation
    load(fullfile(DataDirLoad,'02_HarmonicDescriptors.mat'),'HarmonicDescriptors');
    SpectralParticipation = ...
        HarmonicDescriptors.SpectralParticipation(:,SubjectIndices.RawSCAnalysis);

    % Computation of metrics and associations
    RawSCAnalysis = GSPTB_RunRawSCGraphAnalysis(Data.Adj,SpectralParticipation);

    RawSCFile = fullfile(DataDirSave,'04_RawSCAnalysis.mat');
    save(RawSCFile,'RawSCAnalysis','-v7.3');
end



%% 6. Surrogate sparsity analyses (impacts of topology and edge weight)

if Cfg.Run.SurrogateSparsity

    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.SurrogateSparsity;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);

    % Surrogate analysis
    SurrogateSparsityResults = GSPTB_RunSurrogateSparsityAnalysis(Data.Adj,...
    Cfg.Harmonics.SparsityThreshold,Cfg.Harmonics.ReferenceSubject);

    SurrogateSparsityFile = fullfile(DataDirSave,'05_SurrogateAnalysis.mat');
    save(SurrogateSparsityFile,'SurrogateSparsityResults','-v7.3');
end



%% 7. Family organization, statistical probing and family-wise descriptors 

if Cfg.Run.FamilyOrganization

    % Loads realigned harmonics
    load(fullfile(DataDirLoad,'01_Realignment.mat'),'U_R','Lambda_R');
    U_R = U_R(SubjectIndices.FamilyOrganization);
    Lambda_R = Lambda_R(SubjectIndices.FamilyOrganization);

    % Loads harmonic descriptors
    load(fullfile(DataDirLoad,'02_HarmonicDescriptors.mat'),'HarmonicDescriptors');
    HarmonicDescriptors.Stability = GSPTB_ComputeHarmonicStability(U_R);
    HarmonicDescriptors.GraphSupport = ...
        HarmonicDescriptors.GraphSupport(SubjectIndices.FamilyOrganization,:);
    HarmonicDescriptors.Sparsity = ...
        HarmonicDescriptors.Sparsity(SubjectIndices.FamilyOrganization,:);
    HarmonicDescriptors.Localization = ...
        HarmonicDescriptors.Localization(SubjectIndices.FamilyOrganization,:);
    HarmonicDescriptors.SpannedConnectivity = ...
        HarmonicDescriptors.SpannedConnectivity(SubjectIndices.FamilyOrganization,:);

    % Cross-subject similarity curve
    CrossSubjSim.Curve = GSPTB_ComputeCrossSubjSimilarityCurve(U_R);
    
    % Cross-subject similarity matrix
    CrossSubjSim.Matrix = GSPTB_ComputeCrossSubjSimilarityMatrix(U_R);

    % Extracts families from the matrix
    Families = GSPTB_ExtractFamilies(CrossSubjSim.Matrix,Cfg.FamilyOrganization);
    
    % Gets all family-wise descriptors in a dedicated struct
    FamilyDescriptors = GSPTB_ComputeFamilyWiseDescriptors(Families.Indices,...
        Lambda_R,HarmonicDescriptors);
    
    % Computes actual similarity statistic
    [DeltaSim,WithinSim,AcrossSim] = ...
        GSPTB_ComputeFamilyDeltaSim(CrossSubjSim.Matrix,Families.Indices);
    
    % Computes null similarity stat distribution
    DeltaSimNull = GSPTB_ComputeFamilyDeltaNull(CrossSubjSim.Matrix,...
        FamilyDescriptors.Size,Cfg.Statistics.FamilyDelta.NumNulls);

    FamilyFile = fullfile(DataDirSave,'06_FamilyAnalysis.mat');
    save(FamilyFile,'CrossSubjSim','WithinSim','AcrossSim','Families',...
        'FamilyDescriptors','DeltaSim','DeltaSimNull','-v7.3');
end



%% 8. Behavioral prediction harmonic-wise and family-wise

if Cfg.Run.BehaviorPrediction

    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.BehaviorPrediction;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);

    % Loads realigned harmonics
    load(fullfile(DataDirLoad,'01_Realignment.mat'),'U_R','Lambda_R');
    U_R = U_R(SubjectIndices.BehaviorPrediction);
    Lambda_R = Lambda_R(SubjectIndices.BehaviorPrediction);

    % Loads family information
    load(fullfile(DataDirLoad,'06_FamilyAnalysis.mat'),'Families');
    
    PredOpts.NumOuterSplits = Cfg.Prediction.NumOuterSplits;
    PredOpts.NumInnerFolds = Cfg.Prediction.NumInnerFolds;
    PredOpts.LeftOutFraction = Cfg.Prediction.LeftOutFraction;
    PredOpts.Lambda = Cfg.Prediction.Lambda;
    PredOpts.FamilyKernel = Data.FamilyKernel;
    PredOpts.Covariate = Data.MeanFD;
    PredOpts.NormalizeHarmonicAdjacency = Cfg.Harmonics.NormalizeAdjacency;

    % Adds the splits; this is useful to run other predictions using
    % the same subject splitting scheme
    PredOpts.Splits = GSPTB_CreatePredictionSplits(PredOpts);

    % As an example, we compute the cumulative prediction from
    % low-frequency harmonics
    PredType = 'cumlow';
    tmp_res = GSPTB_RunHarmonicWisePredictionCurve(U_R,Lambda_R,Data.DegMat,...
        PredType,Data.FactorScores.Cognition,PredOpts);
    BehavioralPrediction.HarmonicWise.Cognition.CumLow = tmp_res;

    BehavioralPrediction.FamilyWise = GSPTB_RunFamilyWisePrediction(U_R,Lambda_R,...
    Data.DegMat,Families.Indices,Data.FactorScores.Cognition,PredOpts);

    BehavioralPredictionFile = fullfile(DataDirSave,'07_BehavioralPrediction.mat');
    save(BehavioralPredictionFile,'BehavioralPrediction','-v7.3');
end



%% 9. Sparse representation of fMRI activity and dynamic metrics

if Cfg.Run.DynamicAnalysis

    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.DynamicAnalysis;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);

    % Runs one representative task in the reduced test workflow. (EMOTION
    % task, the only one with functional data included in the repository)
    % Full results for all tasks are provided in data/intermediate/full
    task_OI = 1;
    task_OI_name = Cfg.Tasks.Names{task_OI};

    % Loads realigned harmonics
    load(fullfile(DataDirLoad,'01_Realignment.mat'),'U_R');
    U_R = U_R(SubjectIndices.DynamicAnalysis);
    
    SparsePredictionResults = cell(1,1);
    DynamicMetrics = cell(1,1);

    PathDyn.Functional = fullfile(RootDir,'data','inputs');

    % Same process for each task...
    id_task = 1;
    for t = task_OI
        [DynamicMetrics{id_task},SparsePredictionResults{id_task}] = ...
            GSPTB_RunCohortDynamicAnalysis(Cfg,PathDyn,U_R,t);

        id_task = id_task + 1;
    end

    DynamicAnalysisFile = fullfile(DataDirSave,'08_DynamicAnalysis.mat');
    save(DynamicAnalysisFile,'DynamicMetrics','SparsePredictionResults',...
        'task_OI','task_OI_name','-v7.3');
end



%% 10. Statistical analysis of head motion/task relationships

if Cfg.Run.MovementAnalysis
        
    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.MovementAnalysis;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);

    % Loads realigned harmonics
    load(fullfile(DataDirLoad,'08_DynamicAnalysis.mat'),'DynamicMetrics');
    
    NumTasks = numel(Cfg.Tasks.Names);
    for t = 1:NumTasks
        DynamicMetrics{t}.MeanIntensity = ...
            DynamicMetrics{t}.MeanIntensity(:,SubjectIndices.MovementAnalysis);
        DynamicMetrics{t}.EntryRate = ...
            DynamicMetrics{t}.EntryRate(:,SubjectIndices.MovementAnalysis);
        DynamicMetrics{t}.Duration = ...
            DynamicMetrics{t}.Duration(:,SubjectIndices.MovementAnalysis);
    end

    % Computes the statistics
    MovementStatistics = GSPTB_RunMovementStatistics(Data);
    MovementExpressionStatistics = ...
        GSPTB_RunMovementExpressionAnalysis(Data.MeanFD,DynamicMetrics);

    MovementAnalysisFile = fullfile(DataDirSave,'09_MovementAnalysis.mat');
    save(MovementAnalysisFile,'MovementStatistics','MovementExpressionStatistics','-v7.3');
end



%% 11. Varying expression of dynamic harmonic metrics across tasks

if Cfg.Run.TaskContrasts
        
    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.TaskContrasts;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);

    % Loads realigned harmonics
    load(fullfile(DataDirLoad,'08_DynamicAnalysis.mat'),'DynamicMetrics');
    
    NumTasks = numel(Cfg.Tasks.Names);
    for t = 1:NumTasks
        DynamicMetrics{t}.MeanIntensity = ...
            DynamicMetrics{t}.MeanIntensity(:,SubjectIndices.TaskContrasts);
        DynamicMetrics{t}.EntryRate = ...
            DynamicMetrics{t}.EntryRate(:,SubjectIndices.TaskContrasts);
        DynamicMetrics{t}.Duration = ...
            DynamicMetrics{t}.Duration(:,SubjectIndices.TaskContrasts);
    end

    % Recomputes statistics for required number of subjects
    MovementExpressionStatistics = ...
        GSPTB_RunMovementExpressionAnalysis(Data.MeanFD,DynamicMetrics);

    % Task contrasts are computed
    TaskContrastResults = GSPTB_LME_TaskContrastsAcrossMetrics(MovementExpressionStatistics,Cfg);
    TaskContrastResults_Supplementary = GSPTB_Ranksum_TaskContrastsAcrossMetrics(DynamicMetrics,Cfg);

    TaskContrastFile = fullfile(DataDirSave,'10_TaskContrasts.mat');
    save(TaskContrastFile,'TaskContrastResults',...
        'TaskContrastResults_Supplementary','-v7.3');
end



%% 12. Prediction of cognition with structure, function or both together

if Cfg.Run.ArchitectureAnalysis

    % Loading the data (right amount of subjects)
    Cfg.Data.ToLoad = SubjectIndices.ArchitectureAnalysis;
    Data = GSPTB_LoadPaper1Data(Cfg,InputDataDir);

    % Loading of realigned harmonics
    load(fullfile(DataDirLoad,'01_Realignment.mat'),'U_R');
    U_R = U_R(SubjectIndices.ArchitectureAnalysis);

    % Loading of sparse representations to compute power
    load(fullfile(DataDirLoad,'08_DynamicAnalysis.mat'),'SparsePredictionResults');

    NumTasks = numel(Cfg.Tasks.Names);
    for t = 1:NumTasks
        SparsePredictionResults{t} = ...
            SparsePredictionResults{t}(SubjectIndices.ArchitectureAnalysis);
    end

    % Computation of power
    Power = NaN(NumTasks,length(SubjectIndices.ArchitectureAnalysis),...
        size(Data.Adj{1},1));
    
    for t = 1:NumTasks
        for s = 1:length(SubjectIndices.ArchitectureAnalysis)
            tmp_weights = SparsePredictionResults{t}{s}.Weights;
            Power(t,s,:) = GSPTB_ComputePower(tmp_weights,...
                Data.FD_TimeCourses{t}{s},Cfg.Data.ScrubbingThreshold);
        end
    end

    PredOpts.NumOuterSplits = Cfg.Prediction.NumOuterSplits;
    PredOpts.NumInnerFolds = Cfg.Prediction.NumInnerFolds;
    PredOpts.LeftOutFraction = Cfg.Prediction.LeftOutFraction;
    PredOpts.Lambda = Cfg.Prediction.Lambda;
    PredOpts.FamilyKernel = Data.FamilyKernel;
    PredOpts.Covariate = Data.MeanFD;
    PredOpts.NormalizeHarmonicAdjacency = Cfg.Harmonics.NormalizeAdjacency;

    % Adds the splits; this is useful to run other predictions using
    % the same subject splitting scheme
    PredOpts.Splits = GSPTB_CreatePredictionSplits(PredOpts);

    % Runs the full pipeline: kernel generation and prediction for all subtypes
    % of kernels
    % The last task is excluded to avoid over-representation of the REST
    % condition, as there were two such scans (task indices 8 and 9)
    [Kernels,ArchitectureResults] = GSPTB_RunArchitectureComparison(U_R,...
        Power(1:NumTasks-1,:,:),Data.FactorScores.Cognition,Cfg,PredOpts);

    ArchitectureAnalysisFile = fullfile(DataDirSave,'11_ArchitectureAnalysis.mat');

    save(ArchitectureAnalysisFile,'Power','Kernels','ArchitectureResults', ...
    '-v7.3');
end