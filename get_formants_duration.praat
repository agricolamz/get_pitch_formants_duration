# This is a Praat script made for investigation of Abaza vowels. It analyses multiple selected sounds 
# (TextGrids should be also uploaded to Praat Obects). The file should have the following structure:
# * first tier --- sound label
# * second tier --- utterance label
# * third tier --- word label
# * forth tier --- translation label
# * fifth tier --- speaker id

# This script is distributed under the GNU General Public License.
# George Moroz 15.07.2018

form Get Pitch listing from a file
  comment Where should the script write a result file
  text directory /home/agricolamz/work/materials/2018_Abaza_expedition/sound/final/
  comment How should the script name a result file
  text resultfile pitch-formnat-duration-log.csv
  comment Time step
  integer step 0.01
  comment Pitch floor (Hz)
  integer floor 75
  comment Pitch ceiling (Hz)
  integer ceiling 250
  comment 5. formant ceiling (Hz)
  integer fceiling 5500
endform

n = numberOfSelected("Sound")
for j to n
	sound[j] = selected("Sound", j)
endfor
for k to n
	selectObject: sound[k]
	object_name$ = selected$ ("Sound")
	select TextGrid 'object_name$'
	number_of_intervals = Get number of intervals... 1
			for b from 1 to number_of_intervals
				select TextGrid 'object_name$'
				interval_label$ = Get label of interval... 1 'b'
				utterance$ = Get label of interval... 2 'b'
				if interval_label$ <> ""
					start = Get starting point... 1 'b'
					end = Get end point... 1 'b'
                    			duration = end - start
					int_1 = Get interval at time... 3 end
					word$ = Get label of interval... 3 int_1
					trans$ = Get label of interval... 4 int_1
					int_2 = Get interval at time... 5 end
					speaker$ = Get label of interval... 5 int_2
					select Sound 'object_name$'
					s = Extract part: start, end, "rectangular", 1, "yes"
					select s
					fragment_name$ = selected$ ("Sound")
					pitch = To Pitch... step floor ceiling
					selectObject: s
					formant = To Formant (burg): 0, 5, fceiling, 0.025, 50
					i = start
					while i <= end
						select Pitch 'fragment_name$'
						f0 = Get value at time... 'i' Hertz Linear
						select Formant 'fragment_name$'
						f1 = Get value at time: 1, i, "Hertz", "Linear"
						f2 = Get value at time: 2, i, "Hertz", "Linear"
						f3 = Get value at time: 3, i, "Hertz", "Linear"
						f1b = Get value at time: 1, i, "Bark", "Linear"
						f2b = Get value at time: 2, i, "Bark", "Linear"
						f3b = Get value at time: 3, i, "Bark", "Linear"
						i = i + 0.01
						fileappend "'directory$''resultfile$'" 'object_name$''tab$''interval_label$''tab$''utterance$''tab$''word$''tab$''trans$''tab$''speaker$''tab$''f0''tab$''f1''tab$''f2''tab$''f3''tab$''f1b''tab$''f2b''tab$''f3b''tab$''duration''tab$''i''newline$'
					endwhile
					removeObject: s
					removeObject: pitch
					removeObject: formant
				endif
			endfor
#	removeObject: "Sound 'object_name$'"
#	removeObject: "TextGrid 'object_name$'"
endfor

