FUNCTION mk_rccm_2, $
   rccm_1, $
   misr_path, $
   misr_orbit, $
   misr_block, $
   rccm_2, $
   n_miss_2, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function attempts to replace missing values in the
   ;  rccm_1 cloud mask by reasonable estimates determined on the basis of
   ;  the values of its immediate neighbors.
   ;
   ;  ALGORITHM: This function uses square sub-windows of various sizes,
   ;  within the input array rccm_1 and centered on each successive
   ;  missing pixel, to compute basic non-parametric statistics on the
   ;  frequencies of neighboring values and propose a reasonable
   ;  replacement value.
   ;
   ;  SYNTAX: rc = mk_rccm_2(rccm_1, misr_path, misr_orbit, $
   ;  misr_block, rccm_2, n_miss_2, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   rccm_1 {BYTE array} [I]: An array containing the updated RCCM
   ;      product for the 9 camera files corresponding to the selected
   ;      MISR PATH, ORBIT and BLOCK, i.e., with non zero values for edge
   ;      and obscured pixels.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  *   rccm_2 {BYTE array} [O]: An array containing the upgraded RCCM
   ;      product for the 9 camera files where most if not all of the
   ;      missing values are replaced by reasonable estimates of the local
   ;      cloudiness.
   ;
   ;  *   n_miss_2 {LONG array} [O]: An array reporting how many missing
   ;      values (0B) remain in each of these 9 cloud masks.
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
   ;      provided in the call. The output positional parameters rccm_2
   ;      and n_miss_2 contain the upgraded cloud masks and the number of
   ;      remaining missing values in each of them, respectively. The
   ;      meaning of pixel values is as follows:
   ;
   ;      -   0B: Missing.
   ;
   ;      -   1B: Cloud with high confidence.
   ;
   ;      -   2B: Cloud with low confidence.
   ;
   ;      -   3B: Clear with low confidence.
   ;
   ;      -   4B: Clear with high confidence.
   ;
   ;      -   253B: Obscured.
   ;
   ;      -   254B: Edge.
   ;
   ;      -   255B: Fill.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters rccm_2 and n_miss_2
   ;      may be inexistent, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter rccm_1 is invalid.
   ;
   ;  *   Error 120: Input positional parameter misr_path is invalid.
   ;
   ;  *   Error 130: Input positional parameter misr_orbit is invalid.
   ;
   ;  *   Error 140: Input positional parameter misr_block is invalid.
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
   ;  *   Error 400: An exception condition occurred in the function
   ;      repl_box.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   repl_box.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None
   ;
   ;  EXAMPLES:
   ;
   ;      [See the outcome(s) generated by get_l1rccm.pro]
   ;
   ;  REFERENCES: None.
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
   ;  *   2019–01–30: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–02–02: Version 2.01 — Delete unused variable pob_str.
   ;
   ;  *   2019–02–05: Version 2.10 — Implement new algorithm (multiple
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
            ' positional parameter(s): rccm_1, misr_path, misr_orbit, ' + $
            'misr_block, rccm_2, n_miss_2.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'rccm_1' is not a properly dimensioned BYTE array:
      sz = SIZE(rccm_1)
      IF ((sz[0] NE 3) OR $
         (sz[1] NE 9) OR $
         (sz[2] NE 512) OR $
         (sz[3] NE 128) OR $
         (sz[4] NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Positional parameter rccm_1 is invalid.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   cams = misr_specs.CameraNames
   n_bnds = misr_specs.NBands
   bnds = misr_specs.BandNames

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

   ;  Define and initialize rccm_2 with rccm_1:
   rccm_2 = rccm_1
   n_miss_2 = LONARR(n_cams)

   ;  Loop over the 9 camera files:
   FOR cam = 0, n_cams - 1 DO BEGIN

   ;  Generate a temporary 2D cloud mask for the current camera and generate
   ;  a list of the missing pixels in that cloud mask:
      cld_msk = REFORM(rccm_1[cam, *, *])
      idx = WHERE(cld_msk EQ 0B, count)

   ;  If there are no missing values, proceed to the next camera:
      IF (count EQ 0) THEN CONTINUE

print, 'cam = ' + cams[cam] + ': initial # miss vals = ' + strstr(count)

   ;  =========================================================================
   ;  Step 1: Repeatedly scan the cloud mask to replace missing values
   ;  surrounded by at least 4 HOMOGENEOUS valid neighbors within a 3x3
   ;  sub-window:
      iter = 0
      box_inc = 1
      min_num_required = 4
      homogeneous = 1
      REPEAT BEGIN
         n_proc = 0L

         IF (count GT 0) THEN BEGIN

   ;  Define the arrays containing the coordinates of those missing pixels:
            mpix_sample = INTARR(count)
            mpix_line = INTARR(count)

   ;  Loop over the missing pixels of the current camera
            FOR mpix = 0, count - 1 DO BEGIN

   ;  Retrieve the image coordinates of the current missing pixel:
               mpix_loc = ARRAY_INDICES(cld_msk, idx[mpix])
               mpix_sample[mpix] = mpix_loc[0]
               mpix_line[mpix] = mpix_loc[1]

   ;  Analyze the subwindow centered on the missing pixel to determine a
   ;  reasonable replacement value:
               rc = repl_box(cld_msk, mpix_sample[mpix], mpix_line[mpix], $
                  box_inc, min_num_required, value, HOMOGENEOUS = homogeneous, $
                  DEBUG = debug, EXCPT_COND = excpt_cond)
               IF (excpt_cond NE '') THEN BEGIN
                  error_code = 400
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': ' + excpt_cond
                  RETURN, error_code
               ENDIF

   ;  If a replacement value has been found (homogeneous case), copy it back
   ;  into the temporary cloud mask for the current camera:
               IF (rc GE 0) THEN BEGIN
                  n_proc++
                  cld_msk[idx[mpix]] = value
               ENDIF
            ENDFOR

   ;  Copy the temporary cld_msk back into the rccm_2 array:
            rccm_2[cam, *, *] = cld_msk
         ENDIF

   ;  Check whether there are any remaining missing pixels in this camera
   ;  cloud mask:
         iter++
;         kdx = WHERE(cld_msk EQ 0B, cnt)
         idx = WHERE(cld_msk EQ 0B, count)
;         n_miss_2[cam] = cnt
         n_miss_2[cam] = count
         IF (count EQ 0) THEN CONTINUE

   ;  Proceed to the next iteration:
ENDREP UNTIL ((n_proc EQ 0) OR (iter GT 40))

print, 'cam = ' + cams[cam] + ': after step 1, iter = ' + $
   strstr(iter), ' # miss vals = ' + strstr(count)

   ;  =========================================================================
   ;  Step 2: Repeatedly scan the cloud mask to replace missing values
   ;  surrounded by at least 12 HETEROGENEOUS valid neighbors within a 5x5
   ;  sub-window:
      iter = 0
      box_inc = 2
      min_num_required = 12
      homogeneous = 0
      REPEAT BEGIN
         n_proc = 0L

         IF (count GT 0) THEN BEGIN

   ;  Define the arrays containing the coordinates of those missing pixels:
            mpix_sample = INTARR(count)
            mpix_line = INTARR(count)

   ;  Loop over the missing pixels of the current camera
            FOR mpix = 0, count - 1 DO BEGIN

   ;  Retrieve the image coordinates of the current missing pixel:
               mpix_loc = ARRAY_INDICES(cld_msk, idx[mpix])
               mpix_sample[mpix] = mpix_loc[0]
               mpix_line[mpix] = mpix_loc[1]

   ;  Analyze the subwindow centered on the missing pixel to determine a
   ;  reasonable replacement value:
               rc = repl_box(cld_msk, mpix_sample[mpix], mpix_line[mpix], $
                  box_inc, min_num_required, value, HOMOGENEOUS = homogeneous, $
                  DEBUG = debug, EXCPT_COND = excpt_cond)
               IF (excpt_cond NE '') THEN BEGIN
                  error_code = 400
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': ' + excpt_cond
                  RETURN, error_code
               ENDIF

   ;  If a replacement value has been found (homogeneous case), copy it back
   ;  into the temporary cloud mask for the current camera:
               IF (rc GE 0) THEN BEGIN
                  n_proc++
                  cld_msk[idx[mpix]] = value
               ENDIF
            ENDFOR

   ;  Copy the temporary cld_msk back into the rccm_2 array:
            rccm_2[cam, *, *] = cld_msk
         ENDIF

   ;  Check whether there are any remaining missing pixels in this camera
   ;  cloud mask:
         iter++
;         kdx = WHERE(cld_msk EQ 0B, cnt)
         idx = WHERE(cld_msk EQ 0B, count)
;         n_miss_2[cam] = cnt
         n_miss_2[cam] = count
         IF (count EQ 0) THEN CONTINUE

   ;  Proceed to the next iteration:
ENDREP UNTIL ((n_proc EQ 0) OR (iter GT 40))

print, 'cam = ' + cams[cam] + ': after step 2, iter = ' + $
   strstr(iter), ' # miss vals = ' + strstr(count)

   ;  =========================================================================
   ;  Step 3: Repeatedly scan the cloud mask to replace missing values
   ;  surrounded by at least 3 HETEROGENEOUS valid neighbors within a 3x3
   ;  sub-window:
      iter = 0
      box_inc = 1
      min_num_required = 2
      homogeneous = 0
      REPEAT BEGIN
         n_proc = 0L

         IF (count GT 0) THEN BEGIN

   ;  Define the arrays containing the coordinates of those missing pixels:
            mpix_sample = INTARR(count)
            mpix_line = INTARR(count)

   ;  Loop over the missing pixels of the current camera
            FOR mpix = 0, count - 1 DO BEGIN

   ;  Retrieve the image coordinates of the current missing pixel:
               mpix_loc = ARRAY_INDICES(cld_msk, idx[mpix])
               mpix_sample[mpix] = mpix_loc[0]
               mpix_line[mpix] = mpix_loc[1]

   ;  Analyze the subwindow centered on the missing pixel to determine a
   ;  reasonable replacement value:
               rc = repl_box(cld_msk, mpix_sample[mpix], mpix_line[mpix], $
                  box_inc, min_num_required, value, HOMOGENEOUS = homogeneous, $
                  DEBUG = debug, EXCPT_COND = excpt_cond)
               IF (excpt_cond NE '') THEN BEGIN
                  error_code = 400
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': ' + excpt_cond
                  RETURN, error_code
               ENDIF

   ;  If a replacement value has been found (homogeneous case), copy it back
   ;  into the temporary cloud mask for the current camera:
               IF (rc GE 0) THEN BEGIN
                  n_proc++
                  cld_msk[idx[mpix]] = value
               ENDIF
            ENDFOR

   ;  Copy the temporary cld_msk back into the rccm_2 array:
            rccm_2[cam, *, *] = cld_msk
         ENDIF

   ;  Check whether there are any remaining missing pixels in this camera
   ;  cloud mask:
;         kdx = WHERE(cld_msk EQ 0B, cnt)
         idx = WHERE(cld_msk EQ 0B, count)
;         n_miss_2[cam] = cnt
         n_miss_2[cam] = count
         IF (count EQ 0) THEN CONTINUE

   ;  Proceed to the next iteration:
         iter++
      ENDREP UNTIL ((n_proc EQ 0) OR (iter GT 20))

print, 'cam = ' + cams[cam] + ': after step 3, iter = ' + $
   strstr(iter), ' # miss vals = ' + strstr(count)
print

   ENDFOR   ;  End of loop on cameras.

   RETURN, return_code

END
