convert:
	ogr2ogr \
		-s_srs EPSG:2154 \
		-oo X_POSSIBLE_NAMES=x \
		-oo Y_POSSIBLE_NAMES=y \
		-oo KEEP_GEOM_COLUMNS=NO \
		-t_srs EPSG:4326 \
	  -lco GEOMETRY=AS_XY \
		-f CSV \
	  static/bornes.csv \
		data/Bornes_2014.csv

