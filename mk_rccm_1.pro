FUNCTION mk_rccm_1, $
   rccm_0, $
   l1b2_files, $
   misr_path, $
   misr_orbit, $
   misr_block, $
   rccm_1, $
   n_miss_1, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function flags edge and obscured pixels in the
   ;  standard MISR RCCM array rccm_0.
   ;
   ;  ALGORITHM: This function reads the 9 MISR L1B2 data product files
   ;  and extracts the geographical locations containing unobserved vales,
   ;  either because they fall outside of the instrument swath width
   ;  (‘edge’) or because they are unobservable due to the local
   ;  topography, and ports the corresponding flags into the MISR RCCM
   ;  array rccm_0.
   ;
   ;  SYNTAX: rc = mk_rccm_1(rccm_0, l1b2_files, misr_path, $
   ;  misr_orbit, misr_block, rccm_1, n_miss_1, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   rccm_0 {BYTE array} [I]: An array containing the standard RCCM
   ;      product for the 9 camera files corresponding to the selected
   ;      MISR PATH, ORBIT and BLOCK.
   ;
   ;  *   l1b2_files {STRING array} [I]: An array containing the file
   ;      specifications for the 9 L1B2 files corresponding to the
   ;      selected MISR PATH and ORBIT.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  *   rccm_1 {BYTE array} [O]: An array containing the updated RCCM
   ;      product for the 9 camera files corresponding to the selected
   ;      MISR PATH, ORBIT and BLOCK, i.e., with non zero values for edge
   ;      and obscured pixels.
   ;
   ;  *   n_miss_1 {LONG array} [O]: An array reporting how many missing
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
   ;      provided in the call. The output positional parameters rccm_1
   ;      and n_miss_1 contain the updated cloud masks and the number of
   ;      missing values in each of them, respectively. The meaning of
   ;      pixel values is as follows:
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
   ;      provided. The output positional parameters rccm_1 and n_miss_1
   ;      may be inexistent, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter rccm_0 is invalid.
   ;
   ;  *   Error 120: Input positional parameter l1b2_files is invalid.
   ;
   ;  *   Error 130: Input positional parameter misr_path is invalid.
   ;
   ;  *   Error 140: Input positional parameter misr_orbit is invalid.
   ;
   ;  *   Error 150: Input positional parameter misr_block is invalid.
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
   ;  *   Error 300: One of the input MISR L1B2 files exists but is
   ;      unreadable.
   ;
   ;  *   Error 310: An exception condition occurred in the function
   ;      is_readable.pro.
   ;
   ;  *   Error 320: One of the input MISR L1B2 files does not exist.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 610: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  *   Error 620: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  *   Error 630: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  *   Error 640: An exception condition occurred in the MISR TOOLKIT
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
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      [See the outcome(s) generated by get_l1rccm.pro]
   ;
   ;  REFERENCES:
   ;
   ;  *   Mike Bull, Jason Matthews, Duncan McDonald, Alexander Menzies,
   ;      Catherine Moroney, Kevin Mueller, Susan Paradise, Mike
   ;      Smyth (2011) _MISR Data Products Specifications_, JPL D-13963,
   ;      Revision S, Section 6.7.6, p. 85 for the RCCM values and Section
   ;      9.4.4, p. 210 for the AGP values.
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
      n_reqs = 7
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): rccm_0, l1b2_files, misr_path, ' + $
            'misr_orbit, misr_block, rccm_1, n_miss_1.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'rccm_0' is not a properly dimensioned BYTE array:
      sz = SIZE(rccm_0)
      IF ((sz[0] NE 3) OR $
         (sz[1] NE 9) OR $
         (sz[2] NE 512) OR $
         (sz[3] NE 128) OR $
         (sz[4] NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Positional parameter rccm_0 is invalid.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the positional
   ;  parameter 'l1b2_files' is invalid:
      sz = SIZE(l1b2_files)
      IF ((sz[0] NE 1) OR $
         (sz[1] NE 9) OR $
         (sz[N_ELEMENTS(sz) - 2] NE 7)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Positional parameter l1b2_files is invalid.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 150
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
   pob_str = misr_path_str + '_' + misr_orbit_str + '_' + misr_block_str

   ;  Define and initialize rccm_1 with rccm_0:
   rccm_1 = rccm_0
   n_miss_1 = LONARR(n_cams)

   ;  Define the region of interest:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
      misr_block, misr_block, region)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 600
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Status from MTK_SETREGION_BY_PATH_BLOCKRANGE = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Set the L1B2 grids and fields to use:
   l1b2_grid_blue = 'BlueBand'
   l1b2_field_blue = 'Blue Radiance/RDQI'

   l1b2_grid_green = 'GreenBand'
   l1b2_field_green = 'Green Radiance/RDQI'

   l1b2_grid_red = 'RedBand'
   l1b2_field_red = 'Red Radiance/RDQI'

   l1b2_grid_nir = 'NIRBand'
   l1b2_field_nir = 'NIR Radiance/RDQI'

   ;  Loop over the 9 camera files:
   FOR cam = 0, n_cams - 1 DO BEGIN

   ;  Return to the calling routine with an error message if the current L1B2
   ;  file does not exist or is unreadable:
      rc = is_readable(l1b2_files[cam], DEBUG = debug, EXCPT_COND = excpt_cond)
      CASE rc OF
         0: BEGIN
               error_code = 300
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input L1B2 file exists but is unreadable.'
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
                  rout_name + ': The input L1B2 file does not exist.'
               RETURN, error_code
            END
         ELSE: BREAK
      ENDCASE

   ;  Generate a temporary 2D cloud mask for the current camera:
      cld_msk = REFORM(rccm_0[cam, *, *])

   ;  Read the 4 spectral bands of the L1B2, and downscale the high spatial
   ;  resolution arrays to match the size of the cloud mask:
      status = MTK_READDATA(l1b2_files[cam], l1b2_grid_blue, $
         l1b2_field_blue, region, radiance_blue, mapinfo)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 610
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': status from MTK_READDATA = ' + strstr(status)
         RETURN, error_code
      ENDIF
      IF (cams[cam] EQ 'AN') THEN l1b2_blue = hr2lr(radiance_blue) $
      ELSE l1b2_blue = radiance_blue

      status = MTK_READDATA(l1b2_files[cam], l1b2_grid_green, $
         l1b2_field_green, region, radiance_green, mapinfo)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 620
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': status from MTK_READDATA = ' + strstr(status)
         RETURN, error_code
      ENDIF
      IF (cams[cam] EQ 'AN') THEN l1b2_green = hr2lr(radiance_green) $
         ELSE l1b2_green = radiance_green

      status = MTK_READDATA(l1b2_files[cam], l1b2_grid_red, $
         l1b2_field_red, region, radiance_red, mapinfo)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 630
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': status from MTK_READDATA = ' + strstr(status)
         RETURN, error_code
      ENDIF
      l1b2_red = hr2lr(radiance_red)

      status = MTK_READDATA(l1b2_files[cam], l1b2_grid_nir, $
         l1b2_field_nir, region, radiance_nir, mapinfo)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 640
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': status from MTK_READDATA = ' + strstr(status)
         RETURN, error_code
      ENDIF
      IF (cams[cam] EQ 'AN') THEN l1b2_nir = hr2lr(radiance_nir) $
      ELSE l1b2_nir = radiance_nir

   ;  Identify and count the non-retrieved pixels (value 0B):
      idx = WHERE(cld_msk EQ 0B, count)
      FOR i = 0, count - 1 DO BEGIN

   ;  Replace those that correspond to edge (65515) pixels by a flag value:
         IF ((l1b2_blue[idx[i]] EQ 65515) OR $
            (l1b2_green[idx[i]] EQ 65515) OR $
            (l1b2_red[idx[i]] EQ 65515) OR $
            (l1b2_nir[idx[i]] EQ 65515)) THEN BEGIN
            cld_msk[idx[i]] = 254B
         ENDIF

   ;  Replace those that correspond to obscured (65511) pixels by a flag value:
         IF ((l1b2_blue[idx[i]] EQ 65511) OR $
            (l1b2_green[idx[i]] EQ 65511) OR $
            (l1b2_red[idx[i]] EQ 65511) OR $
            (l1b2_nir[idx[i]] EQ 65511)) THEN BEGIN
            cld_msk[idx[i]] = 253B
         ENDIF
      ENDFOR

   ;  Copy this temporary cloud mask into rccm_1 and count the missing pixels:
      rccm_1[cam, *, *] = cld_msk
      idx = WHERE(cld_msk EQ 0B, cnt)
      n_miss_1[cam] = cnt

   ENDFOR

   RETURN, return_code

END
