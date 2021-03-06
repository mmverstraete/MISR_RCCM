FUNCTION set_rccm_folder, $
   misr_path, $
   rccm_fpath, $
   n_rccm_files, $
   RCCM_FOLDER = rccm_folder, $
   RCCM_VERSION = rccm_version, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function sets the path to the folder containing the
   ;  MISR RCCM files for the specified PATH.
   ;
   ;  ALGORITHM: By default, this function sets the path to the folder
   ;  containing the MISR RCCM files according to the settings included in
   ;  the function set_roots_vers; the optional input keyword parameter
   ;  rccm_folder overrides this setting. The function also checks that
   ;  this folder is available for reading.
   ;
   ;  SYNTAX: rc = set_rccm_folder(misr_path, rccm_fpath, n_rccm_files, $
   ;  RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   rccm_fpath {STRING} [O]: The path to the folder containing the
   ;      MISR RCCM files for the specified PATH.
   ;
   ;  *   n_rccm_files {LONG} [O]: The number of RCCM files residing in
   ;      the rccm_folder.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   RCCM_FOLDER = rccm_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR RCCM files, if they are not located in the
   ;      default location.
   ;
   ;  *   RCCM_VERSION = rccm_version {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The MISR RCCM version identifier to use
   ;      instead of the default value.
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
   ;      provided in the call. The output positional parameter rccm_fpath
   ;      contains the the path to the folder containing the MISR RCCM
   ;      files for the specified PATH.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter rccm_fpath may be
   ;      undefined, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 299: The computer is not recognized and the optional input
   ;      keyword parameter rccm_folder is not specified.
   ;
   ;  *   Error 300: The input folder rccm_path does not exist.
   ;
   ;  *   Error 310: The input folder rccm_path points to multiple
   ;      directories.
   ;
   ;  *   Error 320: The folder rccm_path exists but is unreadable.
   ;
   ;  *   Error 330: The folder rccm_path does not contain any RCCM files.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_readable_file.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> rccm_folder = ''
   ;      IDL> rccm_version = ''
   ;      IDL> rc = set_rccm_folder(misr_path, rccm_fpath, $
   ;         n_rccm_files, RCCM_FOLDER = rccm_folder, $
   ;         RCCM_VERSION = rccm_version, VERBOSE = verbose, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc
   ;             0
   ;
   ;  REFERENCES:
   ;
   ;  *   Michel M. Verstraete, Linda A. Hunt, Hugo De Lemos and Larry Di
   ;      Girolamo (2019) Replacing Missing Values in the Standard MISR
   ;      Radiometric Camera-by-Camera Cloud Mask (RCCM) Data Product,
   ;      _Earth System Science Data Discussions_, Vol. 2019, p. 1–18,
   ;      available from
   ;      https://www.earth-syst-sci-data-discuss.net/essd-2019-77/ (DOI:
   ;      10.5194/essd-2019-77).
   ;
   ;  *   Michel M. Verstraete, Linda A. Hunt, Hugo De Lemos and Larry Di
   ;      Girolamo (2020) Replacing Missing Values in the Standard MISR
   ;      Radiometric Camera-by-Camera Cloud Mask (RCCM) Data Product,
   ;      _Earth System Science Data_, Vol. 12, p. 611–628, available from
   ;      https://www.earth-syst-sci-data.net/12/611/2020/essd-12-611-2020.html
   ;      (DOI: 10.5194/essd-12-611-2020).
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–05–05: Version 1.0 — Initial release.
   ;
   ;  *   2019–05–06: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–05–07: Version 2.15 — Software version described in the
   ;      preprint published in _ESSD Discussions_ mentioned above.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2020–03–06: Version 2.1.1 — Update the code to handle input path
   ;      names with wildcard characters.
   ;
   ;  *   2020–03–19: Version 2.2.0 — Software version described in the
   ;      peer-reviewed paper published in _ESSD_ referenced above.
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

   ;  Set the default values of flags and essential output keyword parameters:
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
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, rccm_fpath, n_rccm_files.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
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

   ;  Set the MISR and MISR-HR version numbers if they have not been specified
   ;  explicitly:
   IF (~KEYWORD_SET(rccm_version)) THEN rccm_version = versions[5]

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF ((rccm AND (~KEYWORD_SET(rccm_folder)))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Computer is unrecognized, function set_roots_vers.pro did ' + $
            'not assign default folder values, and the optional keyword ' + $
            'parameter rccm_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the directory address of the folder containing the input RCCM files
   ;  if it has not been set previously:
   IF (KEYWORD_SET(rccm_folder)) THEN BEGIN
      rc = force_path_sep(rccm_folder, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      rccm_fpath = rccm_folder
   ENDIF ELSE BEGIN
      rccm_fpath = root_dirs[1] + misr_path_str + PATH_SEP() + $
         'L1_RC' + PATH_SEP()
   ENDELSE

   ;  Convert wildcard characters if any are present:
   tst1 = STRPOS(rccm_fpath, '*')
   tst2 = STRPOS(rccm_fpath, '?')
   IF ((tst1 GE 0) OR (tst2 GE 0)) THEN BEGIN
      fp = FILE_SEARCH(rccm_fpath, COUNT = n_fp)
      IF (debug AND (n_fp NE 1)) THEN BEGIN
         CASE n_fp OF
            0: BEGIN
               error_code = 300
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input folder ' + rccm_fpath + $
                  ' does not exist.'
               RETURN, error_code
            END
            ELSE: BEGIN
               error_code = 310
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input folder ' + rccm_fpath + $
                  ' points to multiple directories.'
               RETURN, error_code
            END
         ENDCASE
      ENDIF
      rccm_fpath = fp[0]
      rc = force_path_sep(rccm_fpath)
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  directory 'rccm_fpath' does not exist or is unreadable:
   res = is_readable_dir(rccm_fpath)
   IF (res EQ 0) THEN BEGIN
      error_code = 320
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': The input file ' + rccm_fpath + $
         ' is not found, not a regular file or not readable.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  directory 'rccm_fpath' does not contain RCCM files of the specified or
   ;  default Version:
   pattern = rccm_fpath + 'MISR*GRP_RCCM_GM*' + rccm_version + '.hdf'
   rccm_files = FILE_SEARCH(pattern, COUNT = n_rccm_files)
   IF (n_rccm_files EQ 0) THEN BEGIN
      error_code = 330
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The folder ' + rccm_fpath + ' does not contain any RCCM ' + $
         'files for Version ' + rccm_version + '.'
      RETURN, error_code
   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
