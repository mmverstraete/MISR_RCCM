FUNCTION mk_rccm_0, $
   rccm_files, $
   misr_path, $
   misr_orbit, $
   misr_block, $
   rccm_0, $
   n_miss_0, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function retrieves the standard RADIOMETRIC CAMERA TO
   ;  CAMERA CLOUD MASKS (RCCM) from the original MISR data product files.
   ;
   ;  ALGORITHM: This function reads the 9 MISR RCCM data product files
   ;  and extracts the cloud masks.
   ;
   ;  SYNTAX: rc = mk_rccm_0(rccm_files, misr_path, misr_orbit, $
   ;  misr_block, rccm_0, n_miss_0, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   rccm_files {STRING array} [I]: An array containing the file
   ;      specifications for the 9 RCCM files corresponding to the
   ;      selected MISR PATH and ORBIT.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  *   rccm_0 {BYTE array} [O]: An array containing the standard RCCM
   ;      product for the 9 camera files corresponding to the selected
   ;      MISR PATH, ORBIT and BLOCK.
   ;
   ;  *   n_miss_0 {LONG array} [O]: An array reporting how many
   ;      non-retrieved values (0B) exist in each of these 9 cloud masks.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
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
   ;      provided in the call. The output positional parameters rccm_0
   ;      and n_miss_0 contain the cloud masks and the number of
   ;      non-retrieved values in each of them, respectively. The meaning
   ;      of pixel values is as follows:
   ;
   ;      -   0B: No retrieval.
   ;
   ;      -   1B: Cloud with high confidence.
   ;
   ;      -   2B: Cloud with low confidence.
   ;
   ;      -   3B: Clear with low confidence.
   ;
   ;      -   4B: Clear with high confidence.
   ;
   ;      -   255B: Fill.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters rccm_0 and n_miss_0
   ;      may be inexistent, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_path is invalid.
   ;
   ;  *   Error 120: Input positional parameter misr_orbit is invalid.
   ;
   ;  *   Error 130: Input positional parameter misr_block is invalid.
   ;
   ;  *   Error 200: An exception condition occurred in the function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in the function
   ;      orbit2str.peo.
   ;
   ;  *   Error 220: An exception condition occurred in the function
   ;      block2str.pro.
   ;
   ;  *   Error 300: One of the input MISR RCCM files exists but is
   ;      unreadable.
   ;
   ;  *   Error 310: An exception condition occurred in the function
   ;      is_readable.pro.
   ;
   ;  *   Error 320: One of the input MISR RCCM files does not exist.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 610: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   is_readable.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      [See the outcome(s) generated by fix_rccm.pro]
   ;
   ;  REFERENCES:
   ;
   ;  *   Mike Bull, Jason Matthews, Duncan McDonald, Alexander Menzies,
   ;      Catherine Moroney, Kevin Mueller, Susan Paradise, Mike
   ;      Smyth (2011) _MISR Data Products Specifications_, JPL D-13963,
   ;      Revision S, Section 6.7.6, p. 85.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–08–08: Version 0.8 — Original routines to manipulate MISR
   ;      RCCM data products provided by Linda Hunt.
   ;
   ;  *   2018–12–23: Version 0.9 — Initial release: This function and
   ;      those it depends on supersede all previous routines dealing with
   ;      MISR RCCM data products.
   ;
   ;  *   2018–12–30: Version 1.0 — Initial public release.
   ;
   ;  *   2019–01–30: Version 1.1 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–02–02: Version 1.2 — Delete unused variable pob_str.
   ;
   ;  *   2019–02–05: Version 1.3 — Reorganize the MISR RCCM functions.
   ;
   ;  *   2019–02–18: Version 2.00 — Implement new algorithm (multiple
   ;      scans of the input cloud mask) to minimize artifacts in the
   ;      filled areas.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2019 Michel M. Verstraete.
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
   ;      be included in its entirety in all copies or substantial
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
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 6
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): rccm_files, misr_path, misr_orbit, ' + $
            'misr_block, rccm_0, n_miss_0.'
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

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   cams = misr_specs.CameraNames

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the dimensions of the RCCM cloud masks:
   mask_col = 512
   mask_lin = 128

   ;  Initialize the output positional parameters:
   rccm_0 = BYTARR(n_cams, mask_col, mask_lin)
   n_miss_0 = LONARR(n_cams)

   ;  Define the region of interest:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
      misr_block, misr_block, region)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 600
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Status from MTK_SETREGION_BY_PATH_BLOCKRANGE = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Set the RCCM grids and fields to use:
   rccm_grid = 'RCCM'
   rccm_field_cld = 'Cloud'

   ;  Loop over the 9 camera files:
   FOR cam = 0, n_cams - 1 DO BEGIN

   ;  Return to the calling routine with an error message if the current RCCM
   ;  file does not exist or is unreadable:
      rc = is_readable(rccm_files[cam], DEBUG = debug, EXCPT_COND = excpt_cond)
      CASE rc OF
         0: BEGIN
               error_code = 300
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input RCCM file exists but is unreadable.'
               RETURN, error_code
            END
         -1: BEGIN
               IF (debug) THEN BEGIN
                  error_code = 310
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': ' + excpt_cond
                  RETURN, error_code
               ENDIF
            END
         -2: BEGIN
               error_code = 320
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input RCCM file does not exist.'
               RETURN, error_code
            END
         ELSE: BREAK
      ENDCASE

   ;  Read the cloud mask for the current camera and initialize rccm_0:
      status = MTK_READDATA(rccm_files[cam], rccm_grid, rccm_field_cld, $
         region, cld_msk, mapinfo)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 610
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': status from MTK_READDATA = ' + strstr(status)
         RETURN, error_code
      ENDIF
      rccm_0[cam, *, *] = cld_msk

   ;  Identify the missing pixels in each of the 9 cloud_masks:
      idx = WHERE(cld_msk EQ 0B, cnt)
      n_miss_0[cam] = cnt
   ENDFOR

   RETURN, return_code

END
