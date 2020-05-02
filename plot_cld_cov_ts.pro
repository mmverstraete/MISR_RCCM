FUNCTION plot_cld_cov_ts, $
   cld_cov_fspec, $
   FROM_YMD = from_ymd, $
   UNTIL_YMD = until_ymd, $
   CAL_YEAR = cal_year, $
   PLOT_FOLDER = plot_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function plots the time series of fractional cloud
   ;  cover and saves it in a graphics file.
   ;
   ;  ALGORITHM: This function reads the log file generated by the
   ;  function cld_cov_ts.pro, plots the time series of fractional cloud
   ;  cover between the specified dates, and saves it in a graphics file.
   ;
   ;  SYNTAX: rc = plot_cld_cov_ts(cld_cov_fspec, $
   ;  FROM_YMD = from_ymd, UNTIL_YMD = until_ymd, $
   ;  CAL_YEAR = cal_year, PLOT_FOLDER = plot_folder, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   cld_cov_fspec {STRING} [I] (Default value: None: The file
   ;      specification of the Log file generated by the function
   ;      cld_cov_ts.pro.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   FROM_YMD = from_ymd {STRING} [I] (Default value: 2000-02-24):
   ;      The date of the start of the period to plot.
   ;
   ;  *   UNTIL_YMD = until_ymd {STRING} [I] (Default value: The date of the last available product):
   ;      The date of the end of the period to plot.
   ;
   ;  *   CAL_YEAR = cal_year {INT} [I] (Default value: 0: Flag to request
   ;      (1) or skip (0) plotting the time series for full calendar
   ;      years, as opposed to the strict period from FROM_YMD to
   ;      UNTIL_YMD.
   ;
   ;  *   PLOT_FOLDER = plot_folder {STRING} [I]: The directory address of
   ;      the folder containing the output graphics file.
   ;
   ;  *   VERBOSE = verbose {INT} [I] (Default value: 0): Flag to enable
   ;      (> 0) or skip (0) outputting messages on the console:
   ;
   ;      -   If verbose > 0, messages inform the user about progress in
   ;          the execution of time-consuming routines, or the location of
   ;          output files (e.g., log, map, plot, etc.);
   ;
   ;      -   If verbose > 1, messages record entering and exiting the
   ;          routine; and
   ;
   ;      -   If verbose > 2, messages provide additional information
   ;          about intermediary results.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The graphics file is saved in the default
   ;      or specified folder.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The graphics file may be inexistent, incomplete or
   ;      incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 299: The computer is not recognized and at least one of
   ;      the optional input keyword parameters l1b2_folder, ...,
   ;      map_folder is not specified.
   ;
   ;  *   Error 300: The input file is_readable_file is unfound or
   ;      unreadable.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      chk_ymddate.pro.
   ;
   ;  *   Error 510: An exception condition occurred in function
   ;      chk_ymddate.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   caldate.pro
   ;
   ;  *   chk_ymddate.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_readable_file.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   set_year_range.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> cld_cov_file = '/Users/michel/MISR_HR/Outcomes/
   ;         P169-B110/Log_CloudCover_P169-B110_2020-05-02.txt'
   ;      IDL> from_ymd = ''
   ;      IDL> until_ymd = ''
   ;      IDL> cal_year = 1
   ;      IDL> plot_folder = ''
   ;      IDL> verbose = 1
   ;      IDL> debug = 1
   ;      IDL> rc = plot_cld_cov_ts(cld_cov_file, $
   ;      IDL>    FROM_YMD = from_ymd, UNTIL_YMD = until_ymd, $
   ;      IDL>    CAL_YEAR = cal_year, PLOT_FOLDER = plot_folder, $
   ;      IDL>    VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      The plot file has been saved in /Users/michel/MISR_HR/
   ;         Outcomes/P169-B110/Plot_CloudCover_P169-B110-AN_
   ;         2000-02-24-2018-12-30_2020-05-02.png.
   ;
   ;  REFERENCES:
   ;
   ;  *   Michel M. Verstraete, Linda A. Hunt, Hugo De Lemos and Larry Di
   ;      Girolamo (2019) Replacing Missing Values in the Standard MISR
   ;      Radiometric Camera-by-Camera Cloud Mask (RCCM) Data Product,
   ;      _Earth System Science Data Discussions (ESSDD)_, Vol. 2019, p.
   ;      1–18, available from
   ;      https://www.earth-syst-sci-data-discuss.net/essd-2019-77/ (DOI:
   ;      10.5194/essd-2019-77).
   ;
   ;  *   Michel M. Verstraete, Linda A. Hunt, Hugo De Lemos and Larry Di
   ;      Girolamo (2020) Replacing Missing Values in the Standard MISR
   ;      Radiometric Camera-by-Camera Cloud Mask (RCCM) Data Product,
   ;      _Earth System Science Data (ESSD)_, Vol. 12, p. 611–628,
   ;      available from
   ;      https://www.earth-syst-sci-data.net/12/611/2020/essd-12-611-2020.html
   ;      (DOI: 10.5194/essd-12-611-2020).
   ;
   ;  VERSIONING:
   ;
   ;  *   2020–04–16: Version 1.0 — Initial public release.
   ;
   ;  *   2020–04–18: Version 2.2.0 — Software version brought to the same
   ;      level as the other functions described in the peer-reviewed
   ;      paper published in _ESSD_ referenced above.
   ;
   ;  *   2020–05–02: Version 2.2.1 — Update the code to include the
   ;      camera name in the title of the plot and in the name of the
   ;      output file.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2020 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following three
   ;      conditions:
   ;
   ;      1. The above copyright notice and this permission notice shall
   ;      be included in their entirety in all copies or substantial
   ;      portions of the Software.
   ;
   ;      2. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
   ;      KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
   ;      WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
   ;      AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;      3. The current version of this Software is freely available from
   ;
   ;      https://github.com/mmverstraete.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com
   ;Sec-Cod

   COMPILE_OPT idl2, HIDDEN

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code:
   return_code = 0

   ;  Set the default values of flags and essential keyword parameters:
   IF (KEYWORD_SET(cal_year)) THEN cal_year = 1 ELSE cal_year = 0
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): cld_cov_fspec.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the default folders and version identifiers of the MISR and
   ;  MISR-HR files on this computer, and return to the calling routine if
   ;  there is an internal error, but not if the computer is unrecognized, as
   ;  root addresses can be overridden by input keyword parameters:
   rc_roots = set_roots_vers(root_dirs, versions, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc_roots GE 100)) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF (~KEYWORD_SET(plot_folder)) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + '. And the optional input keyword ' + $
            'parameter PLOT_FOLDER is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Check the existence of the input file:
   rc = is_readable_file(cld_cov_fspec)
   IF (debug AND (rc NE 1)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': The input file ' + cld_cov_fspec + $
         ' is not found, not a regular file or not readable.'
      RETURN, error_code
   ENDIF

   ;  Estimate the number of data lines in the input Log file and open it:
   n_lines = FILE_LINES(cld_cov_fspec) - 14
   OPENR, in_unit, cld_cov_fspec, /GET_LUN

   ;  Set the data arrays:
   juldays = LONARR(n_lines)
   cld_hi = LONARR(n_lines)
   cld_lo = LONARR(n_lines)
   clr_lo = LONARR(n_lines)
   clr_hi = LONARR(n_lines)
   cld_frac = FLTARR(n_lines)

   ;  Read the file header and retrieve the MISR Path, Block and camera:
   line = ''
   FOR i = 0, 8 DO READF, in_unit, line
   READF, in_unit, line
   parts = STRSPLIT(line, ':', /EXTRACT)
   misr_path_str = strstr(parts[1])
   READF, in_unit, line
   parts = STRSPLIT(line, ':', /EXTRACT)
   misr_block_str = strstr(parts[1])
   READF, in_unit, line
   parts = STRSPLIT(line, ':', /EXTRACT)
   misr_camera = strstr(parts[1])
   FOR i = 0, 2 DO READF, in_unit, line

   ;  Read the data:
   i = 0
   WHILE(~EOF(in_unit)) DO BEGIN
      READF, in_unit, line
      parts = STRSPLIT(line, ' ', /EXTRACT)
      juldays[i] = LONG(parts[2])
      cld_hi[i] = LONG(parts[3])
      cld_lo[i] = LONG(parts[4])
      clr_lo[i] = LONG(parts[5])
      clr_hi[i] = LONG(parts[6])
      cld_frac[i] = FLOAT(parts[7]) * 100.0
      i++
   ENDWHILE

   ;  Resize the data arrays if necessary:
   n_dat = i
   IF (n_dat LT n_lines) THEN BEGIN
      juldays = juldays[0:n_dat - 1]
      cld_hi = cld_hi[0:n_dat - 1]
      cld_lo = cld_lo[0:n_dat - 1]
      clr_lo = clr_lo[0:n_dat - 1]
      clr_hi = clr_hi[0:n_dat - 1]
      cld_frac = cld_frac[0:n_dat - 1]
   ENDIF

   ;  Set the directory address of the folder containing the output plot file
   ;  if it has not been set previously (by default the same as the input
   ;  directory):
   IF (KEYWORD_SET(plot_folder)) THEN BEGIN
      plot_fpath = plot_folder
   ENDIF ELSE BEGIN
      plot_fpath = FILE_DIRNAME(cld_cov_fspec, /MARK_DIRECTORY)
   ENDELSE
   rc = force_path_sep(plot_fpath)

   ;  Set the starting year, month and day for the time series plot:
   IF (KEYWORD_SET(from_ymd)) THEN BEGIN

   ;  Check the validity of the optional input keyword parameter FROM_YMD:
      rc = chk_ymddate(from_ymd, from_year, from_month, from_day, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 500
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Check that the optional input keyword parameter FROM_YMD does not
   ;  predate the start of MISR operations:
      IF (from_year LE 2000) THEN BEGIN
         IF (from_month LE 2) THEN BEGIN
            IF (from_day LE 24) THEN from_ymd = '2000-02-24'
         ENDIF
      ENDIF

   ;  Compute the corresponding initial Julian date:
      from_jdate = JULDAY(from_month, from_day, from_year)
   ENDIF ELSE BEGIN

   ;  Otherwise, set the initial Julian date to the start of the MISR mission:
      from_jdate = JULDAY(2, 24, 2000)
      rc = caldate(from_jdate, year, month, day, $
         DATE = from_ymd, DEBUG = debug, EXCPT_COND = excpt_cond)
   ENDELSE

   ;  Set the ending year, month and day for the time series plot:
   IF (KEYWORD_SET(until_ymd)) THEN BEGIN

   ;  Check the validity of the optional input keyword parameter UNTIL_YMD:
      rc = chk_ymddate(until_ymd, until_year, until_month, until_day, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 510
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Compute the corresponding final Julian date:
      until_jdate = JULDAY(until_month, until_day, until_year)
   ENDIF ELSE BEGIN

   ;  Otherwise, set the final Julian date to the last date for which data
   ;  are available:
      until_jdate = LONG(juldays[N_ELEMENTS(juldays) - 1])
      rc = caldate(until_jdate, year, month, day, $
         DATE = until_ymd, DEBUG = debug, EXCPT_COND = excpt_cond)
   ENDELSE

   ;  Optionally reset the time range to full calendar years:
   IF (cal_year) THEN BEGIN
      res = set_year_range(from_jdate, until_jdate, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      from_jdate = res[0]
      until_jdate = res[1]
   ENDIF

   ;  Set the definitive time range of the plot as an interval of Julian dates:
   plt_dates = [from_jdate, until_jdate]

   ;  Extract the required data:
   idx = WHERE((juldays GE from_jdate) AND (juldays LE until_jdate), n_plt)
   dates = juldays[idx]
   cldf = cld_frac[idx]

   ;  Set the ranges of geophysical values to plot:
   yrange_0 = 0.0
   yrange_1 = 100.0
   ytitle = 'Fractional cloud cover'
   title_ts = 'Time series of fractional cloud cover for MISR Path ' + $
      misr_path_str + ', Block ' + misr_block_str + ' and Camera ' + $
      misr_camera

   ;  Set the name of the graphics file to save the plot:
   plot_fpath = FILE_DIRNAME(cld_cov_fspec, /MARK_DIRECTORY)
   plot_fname = 'Plot_CloudCover_P' + misr_path_str + $
      '-B' + misr_block_str + '-' + misr_camera + '_' + $
      from_ymd + '-' + until_ymd + '_' + $
      date + '.png'
   plot_fspec = plot_fpath + plot_fname

   ;  Plot the time series:
   ts1 = PLOT(dates, $
      cldf, $
      DIMENSIONS = [2000, 700], $
      XRANGE = plt_dates, $
      XSTYLE = 1, $
      XTICKUNITS = ['Year'], $
      XTICKINTERVAL = 2, $
      XTITLE = 'Date', $
      XTICKFONT_SIZE = 16, $
      YRANGE = [yrange_0, yrange_1], $
      YSTYLE = 1, $
      YTITLE = ytitle, $
      YTICKFONT_SIZE = 16, $
      TITLE = title_ts, $
      FONT_SIZE = 20, $
      COLOR = black)
   ts1.Save, plot_fspec
   ts1.Close

   IF (verbose GT 0) THEN BEGIN
      PRINT, 'The plot file has been saved in ' + plot_fspec + '.'
   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END