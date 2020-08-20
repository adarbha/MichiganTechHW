% ----------------------------------------------------------------------------------------------------------------------------------------------
%
% FILE: ref_press.m
%
% AUTHOR(S): Jeffrey D. Naber
%
% DESCRIPTION: References In-cylinder Pressure to reference pressure for use combustion analysis (i.e., IMEP, Heat Release).
%
% ----------------------------------------------------------------------------
%   
%    [pr, po] = ref_press(ca, p, pref, win_start, win_stop) 
%
%                       
%       INPUTS          Comment                                             Type            Type            Units                       Default
%       ---------------------------------------------------------------------------------------------------------------------------------------
%           ca          Crank Angle                                         Row Vector      Real            (datdc-firing 0-720)
%           p           In-Cylinder pressure to reference                   Row Vector      Real            (a.u.)
%           pref        Reference Pressure                                  Scalar/Vector   Real          (same a.u.)
%           win_start   ca for window reference start                       Scalar          Real            (datdc)
%           win_stop    ca for window reference stop                        Scalar          Real            (datdc)
%           
%      OUTPUTS          Comment                                             Type            Type            Units    
%       ----------------------------------------------------------------------------------------------------------------------------------------
%           pr          In-cylinder pressure after referencing              Vector          Real            (same a.u.)
%           po          Pressure offset from 'p' to get 'pr'                Vector          Real            (same a.u.)
%                       (i.e, pr = p-po). You can use this to reference 
%                       other derivatives of the same pressure (i.e, 
%                       appropriately filtered versions.
%
% -----------------------------------------------------------------------------------------------------------------------------------------------

% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%
% (c) COPYRIGHT 2005
%
% JEFFREY D. NABER
%
% ALL RIGHTS RESERVED
%
% THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE.
% THE COPYRIGHT NOTICE ABOVE DOES NOT EVIDENCE ANY ACTUAL OR
% INTENDED PUBLICATION OF SUCH SOURCE CODE.
%
% DISCLAIMER
% ----------
% THIS PROGRAM IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
% EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
% PROGRAM IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME
% THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
%
% IN NO EVENT, UNLESS AGREED TO IN WRITING BY THE AUTHOR(S), SHALL THIS PROGRAM
% BE REDISTRIBUTED TO ANY PARTIES WITHIN OR OUTSIDE THE RECEIVING INDIVIDUAL(S). 
% AUTHORIZATION WILL BE ISSUED IN THE FORM OF A NON-DISCLOSURE AGREEMENT. THE AUTHOR(S)
% WILL NOT BE LIABLE FOR ANY DAMAGES, INCLUDING GENERAL, SPECIAL, INCIDENTAL OR 
% CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM
% (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED
% INACCURATE OR LOSSES SUSTAINED BY YOU OR A FAILURE OF THE PROGRAM TO
% OPERATE WITH ANY OTHER PROGRAMS).
%
% ______________________________________________________________________________

% VERSION HISTORY:
%
%   Date        Version         By          Comment
% ---------------------------------------------------------------------------------------------------------------------------------------------
%  20050723     1.0             JDN         New Function (extracted from script plot_pressure_raw.m).
%  20050724     1.1             JDN         Fixed error in the case when pref was a vector.
%                                           Added comments and tested functionality for Motorola DASEC (Louis Liu, Jack Szyptman).
%                                           Release to: Motorola DASEC
%
%

function [pr, po] = ref_pres(ca, p, pref, win_start, win_stop) 

% Setup FLAGS (SET logical(1) to view plots).
FLAG.DEBUG = logical(0);

% Preset outputs when terminating with error
pr = [];
po = [];

% Check number of input arguments
if (nargin)~=5
    disp(' ');
    disp('     ERROR in function ''ref_press''! Incorrect number of input arguments.');
    disp(' ');
    return;
end

% index vector used for reference below
i = (1:length(ca))';

% Reference negative ca if not 0-720
ca(ca<0) = ca(ca<0)+720;

% Modifiy window crank angles to between 0 and 720
win_start = mod(win_start, 720);
win_stop  = mod(win_stop,  720);

% Generated index vectors
if win_start < win_stop
    win  = ca>=win_start & ca<=win_stop;
else
    win  = ca>=win_start | ca<=win_stop;
end

% Get indexes at end of windows:
% - Note if window still open at end of sample, will not select
win_end = find(diff(win)==-1)+1;

% Remove a window that starts before the beginning of a sample
% or within the 'win_buffer'
win_buffer = 500;              
if any(win(1:win_buffer)==1)
    win(1:win_end(1)) = logical(0);
    win_end = win_end(2:end);
end

% Generate normalization vector
xn = cumsum(win);

% - Get vectors of integrated values and normalize
%   - Select values at end of windows (later diff to get values)
xn = xn(win_end);

% - Prepair for diff-ing 
ll = length(xn);
xn(2:ll+1) = xn;   xn(1) = 0;
clear ll 

% Process for max values and correlation
% - Generate a vector of start and stop indicies to the x and y vectors
%   Note we are using a fixed window with in samples to enable vector processing using the max function
%            window_start_index          end_index
win_max = [win_end-ceil(median(diff(xn))) win_end];    

% - Check to ensure the first window does not start before first sample
%   also include 500 sample buffer for filter settleing
if (win_max(1,1)<=win_buffer) 
  win_end = win_end(2:end);
  win_max = win_max(2:end,:);
end

% - Check to ensure the last window does not end after the last sample
n = length(ca);
if (win_end>n) 
  win_end = win_end(1:end-1);
  win_max = win_max(1:end-1,:);
end
    
% - Generate the matrix of indicies to use in finding maximum
n                = ceil(median(diff(xn))); 
win_indicies     =  ( win_end * ones(1,n) )  -   ( ones(length(win_end),1) * [(n-1):-1:0] );

% Find means at windows to use for interpolation
im = mean(i(win_indicies),2);
pm = mean(p(win_indicies),2);

% Use first and last window to set end points to avoid extrapolation
im = [1 im' i(end)]';
pm = [pm(1) pm' pm(end)]';


% - Fit pressure to reference points
po = interp1(im, pm, i, 'spline');


% Reference to pref
if length(pref)==1
    po = pref - po;                             % Scalar
else
    prefm = mean(pref(win_indicies),2);         % When it is a vector the same length as ca and p
    prefm = [prefm(1) prefm' prefm(end)]';
    po = interp1(im, prefm, i, 'spline') - po;
end

% Reference pressure
pr = p + po;

if FLAG.DEBUG
    figure;
        % - Plot pressures prior to offset
        subplot(2,1,1);    
            plot(im, pm, '.', i, -(po-mean(pref)), 'r');

        % - Plot offset
        subplot(2,1,2)
            plot(ca, pr, ca, win*0.25*max(pr), 'r');
end