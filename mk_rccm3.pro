FUNCTION mk_rccm3, $
   rccm_2, $
   rccm_3, $
   n_miss_3, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function attempts to replace missing values in the
   ;  rccm_2 cloud mask by reasonable estimates determined on the basis of
   ;  the values of its immediate neighbors.
   ;
   ;  ALGORITHM: This function uses square sub-windows of various sizes,
   ;  within the input array rccm_2 and centered on each successive
   ;  missing pixel, to compute basic non-parametric statistics on the
   ;  frequencies of neighboring values and propose a reasonable
   ;  replacement value.
   ;
   ;  SYNTAX: rc = mk_rccm3(rccm_2, rccm_3, n_miss_3, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   rccm_2 {BYTE array} [I]: An array containing the upgraded RCCM
   ;      product for the 9 camera files corresponding to the selected
   ;      MISR PATH, ORBIT and BLOCK, i.e., with non zero values for edge
   ;      and obscured pixels, and with some of the missing values already
   ;      replaced by mk_rccm2.pro.
   ;
   ;  *   rccm_3 {BYTE array} [O]: An array containing the upgraded RCCM
   ;      product for the 9 camera files where most if not all of the
   ;      missing values are replaced by reasonable estimates of the local
   ;      cloudiness.
   ;
   ;  *   n_miss_3 {LONG array} [O]: An array reporting how many missing
   ;      values (0B) remain in each of these 9 cloud masks at the end of
   ;      processing in mk_rccm3.pro.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
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
   ;      provided in the call. The output positional parameters rccm_3
   ;      and n_miss_3 contain the upgraded cloud masks and the number of
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
   ;      provided. The output positional parameters rccm_3 and n_miss_3
   ;      may be inexistent, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter rccm_2 is invalid.
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
   ;  *   Error 500: An exception condition occurred in the function
   ;      repl_box.pro.
   ;
   ;  *   Error 510: An exception condition occurred in the function
   ;      repl_box.pro.
   ;
   ;  *   Error 520: An exception condition occurred in the function
   ;      repl_box.pro.
   ;
   ;  *   Error 530: An exception condition occurred in the function
   ;      repl_box.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   block2str.pro
   ;
   ;  *   is_numeric.pro
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
   ;  REMARKS:
   ;
   ;  *   NOTE 1: By default, this function calls the function
   ;      repl_box.pro with the optional keyword parameter VERBOSE set to
   ;      0, irrespective of the value inherited from the calling routine,
   ;      because the latter is called individually for each and every
   ;      missing pixel.
   ;
   ;  EXAMPLES:
   ;
   ;      [See the outcome(s) generated by fix_rccm.pro]
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
   ;
   ;  *   2019–02–27: Version 2.01 — New improved algorithm, capable of
   ;      dealing with cases where most values are missing within a BLOCK,
   ;      as long as values are not missing in neighboring cameras, rename
   ;      this function from mk_rccm_3 to mk_rccm3, and update the
   ;      documentation.
   ;
   ;  *   2019–03–28: Version 2.10 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–05–07: Version 2.15 — Software version described in the
   ;      preprint published in _ESSD Discussions_ mentioned above.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2020–01–06: Version 2.1.1 — Update of the console output when
   ;      verbose is set to 3, and the documentation.
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
            ' positional parameter(s): rccm_2, rccm_3, n_miss_3.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'rccm_2' is not a properly dimensioned BYTE array:
      sz = SIZE(rccm_2)
      IF ((sz[0] NE 3) OR $
         (sz[1] NE 9) OR $
         (sz[2] NE 512) OR $
         (sz[3] NE 128) OR $
         (sz[4] NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Positional parameter rccm_2 is invalid.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   cams = misr_specs.CameraNames
   n_bnds = misr_specs.NBands
   bnds = misr_specs.BandNames

   ;  Define and initialize rccm_3 with rccm_2:
   rccm_3 = rccm_2
   n_miss_3 = LONARR(n_cams)

   ;  Loop over the 9 camera files:
   FOR cam = 0, n_cams - 1 DO BEGIN

   ;  Generate a temporary 2D cloud mask for the current camera and generate
   ;  a list of the missing pixels in that cloud mask:
      cld_msk = REFORM(rccm_2[cam, *, *])
      idx = WHERE(cld_msk EQ 0B, count)

   ;  If there are no missing values, proceed to the next camera:
      IF (count EQ 0) THEN CONTINUE

      IF (verbose GT 2) THEN BEGIN
         ini_miss = count
         PRINT, 'cam = ' + cams[cam] + $
            ': remaining # missing values after rccm2 = ' + strstr(ini_miss)
      ENDIF

   ;  =========================================================================
   ;  Step 1: Repeatedly scan the cloud mask to replace missing values
   ;  surrounded by at least 4 HOMOGENEOUS valid neighbors within a 3x3
   ;  sub-window:
      iter = 0
      box_inc = 1
      box_size = (2 * box_inc) + 1
      min_num_required = 4
      homogeneous = 1
      IF (homogeneous EQ 0) THEN homhet = 'heterogeneous' $
         ELSE homhet = 'homogeneous'

      REPEAT BEGIN
         n_proc = 0L

         IF (count GT 0) THEN BEGIN

   ;  Define the arrays containing the coordinates of those missing pixels:
            mpix_sample = INTARR(count)
            mpix_line = INTARR(count)

   ;  Loop over the missing pixels of the current camera:
            FOR mpix = 0, count - 1 DO BEGIN

   ;  Retrieve the image coordinates of the current missing pixel:
               mpix_loc = ARRAY_INDICES(cld_msk, idx[mpix])
               mpix_sample[mpix] = mpix_loc[0]
               mpix_line[mpix] = mpix_loc[1]

   ;  Analyze the subwindow centered on the missing pixel to determine a
   ;  reasonable replacement value:
               rc = repl_box(cld_msk, mpix_sample[mpix], mpix_line[mpix], $
                  box_inc, min_num_required, value, HOMOGENEOUS = homogeneous, $
                  VERBOSE = 0, DEBUG = debug, EXCPT_COND = excpt_cond)
               IF (excpt_cond NE '') THEN BEGIN
                  error_code = 500
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

   ;  Copy the temporary cld_msk back into the rccm_3 array:
            rccm_3[cam, *, *] = cld_msk
         ENDIF

   ;  Check whether there are any remaining missing pixels in this camera
   ;  cloud mask:
         iter++
         idx = WHERE(cld_msk EQ 0B, count)
         n_miss_3[cam] = count
         IF (count EQ 0) THEN CONTINUE

   ;  Proceed to the next iteration:
      ENDREP UNTIL (n_proc EQ 0)

      IF (verbose GT 2) THEN BEGIN
         PRINT, 'cam = ' + cams[cam] + ': after mk_rccm3 step 1 (' + $
            strstr(box_size) + 'x' + strstr(box_size) + $
            ' box, min valid: ' + strstr(min_num_required) + ', ' + $
            homhet + '), iter = ' + strstr(iter) + $
            ', # replaced = ' + strstr(ini_miss - n_miss_3[cam]) + $
            ', # remaining = ' + strstr(n_miss_3[cam])
         previous_miss = n_miss_3[cam]
      ENDIF

   ;  =========================================================================
   ;  Step 2: Repeatedly scan the cloud mask to replace missing values
   ;  surrounded by at least 12 HETEROGENEOUS valid neighbors within a 5x5
   ;  sub-window:
      iter = 0
      box_inc = 2
      box_size = (2 * box_inc) + 1
      min_num_required = 12
      homogeneous = 0
      IF (homogeneous EQ 0) THEN homhet = 'heterogeneous' $
         ELSE homhet = 'homogeneous'

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
                  VERBOSE = 0, DEBUG = debug, EXCPT_COND = excpt_cond)
               IF (excpt_cond NE '') THEN BEGIN
                  error_code = 510
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

   ;  Copy the temporary cld_msk back into the rccm_3 array:
            rccm_3[cam, *, *] = cld_msk
         ENDIF

   ;  Check whether there are any remaining missing pixels in this camera
   ;  cloud mask:
         iter++
         idx = WHERE(cld_msk EQ 0B, count)
         n_miss_3[cam] = count
         IF (count EQ 0) THEN CONTINUE

   ;  Proceed to the next iteration:
      ENDREP UNTIL (n_proc EQ 0)

      IF (verbose GT 2) THEN BEGIN
         PRINT, 'cam = ' + cams[cam] + ': after mk_rccm3 step 2 (' + $
            strstr(box_size) + 'x' + strstr(box_size) + $
            ' box, min valid: ' + strstr(min_num_required) + ', ' + $
            homhet + '), iter = ' + strstr(iter) + $
            ', # replaced = ' + strstr(previous_miss - n_miss_3[cam]) + $
            ', # remaining = ' + strstr(n_miss_3[cam])
         previous_miss = n_miss_3[cam]
      ENDIF

   ;  =========================================================================
   ;  Step 3: Repeatedly scan the cloud mask to replace missing values
   ;  surrounded by at least 10 HETEROGENEOUS valid neighbors within a 5x5
   ;  sub-window:
      iter = 0
      box_inc = 2
      box_size = (2 * box_inc) + 1
      min_num_required = 10
      homogeneous = 0
      IF (homogeneous EQ 0) THEN homhet = 'heterogeneous' $
         ELSE homhet = 'homogeneous'

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
                  VERBOSE = 0, DEBUG = debug, EXCPT_COND = excpt_cond)
               IF (excpt_cond NE '') THEN BEGIN
                  error_code = 520
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

   ;  Copy the temporary cld_msk back into the rccm_3 array:
            rccm_3[cam, *, *] = cld_msk
         ENDIF

   ;  Check whether there are any remaining missing pixels in this camera
   ;  cloud mask:
         iter++
         idx = WHERE(cld_msk EQ 0B, count)
         n_miss_3[cam] = count
         IF (count EQ 0) THEN CONTINUE

   ;  Proceed to the next iteration:
      ENDREP UNTIL (n_proc EQ 0)

      IF (verbose GT 2) THEN BEGIN
         PRINT, 'cam = ' + cams[cam] + ': after mk_rccm3 step 3 (' + $
            strstr(box_size) + 'x' + strstr(box_size) + $
            ' box, min valid: ' + strstr(min_num_required) + ', ' + $
            homhet + '), iter = ' + strstr(iter) + $
            ', # replaced = ' + strstr(previous_miss - n_miss_3[cam]) + $
            ', # remaining = ' + strstr(n_miss_3[cam])
         previous_miss = n_miss_3[cam]
      ENDIF

   ; =========================================================================
   ;  Step 4: Repeatedly scan the cloud mask to replace missing values
   ;  surrounded by at least 3 HETEROGENEOUS valid neighbors within a 3x3
   ;  sub-window:
      iter = 0
      box_inc = 1
      box_size = (2 * box_inc) + 1
      min_num_required = 3
      homogeneous = 0
      IF (homogeneous EQ 0) THEN homhet = 'heterogeneous' $
         ELSE homhet = 'homogeneous'

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
                  VERBOSE = 0, DEBUG = debug, EXCPT_COND = excpt_cond)
               IF (excpt_cond NE '') THEN BEGIN
                  error_code = 530
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

   ;  Copy the temporary cld_msk back into the rccm_3 array:
            rccm_3[cam, *, *] = cld_msk
         ENDIF

   ;  Check whether there are any remaining missing pixels in this camera
   ;  cloud mask:
         iter++
         idx = WHERE(cld_msk EQ 0B, count)
         n_miss_3[cam] = count
         IF (count EQ 0) THEN CONTINUE

   ;  Stop the processing when no further progress is made:
      ENDREP UNTIL (n_proc EQ 0)

      IF (verbose GT 2) THEN BEGIN
         PRINT, 'cam = ' + cams[cam] + ': after mk_rccm3 step 4 (' + $
            strstr(box_size) + 'x' + strstr(box_size) + $
            ' box, min valid: ' + strstr(min_num_required) + ', ' + $
            homhet + '), iter = ' + strstr(iter) + $
            ', # replaced = ' + strstr(previous_miss - n_miss_3[cam]) + $
            ', # remaining = ' + strstr(n_miss_3[cam])
         PRINT
         previous_miss = n_miss_3[cam]
      ENDIF
   ENDFOR   ;  End of loop on cameras.

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
