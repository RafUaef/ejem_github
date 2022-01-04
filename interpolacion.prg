close @all

import "D:\Paulo Ramos\Nueva carpeta (3)\Inversión hist Bol\Indicadores históricos 1950-2021.xlsx" range=interpolación colhead=1 na="#N/A" @freq A @id @date(t) @smpl @all

rename inv_pub_usd inv_
' Definimos el nombre de la variable
%name= inv_.@name

' Mètodos de interpolacion
' 1. Linear
	{%name}.ipolate {%name}linear
' 2 .Log linear
	{%name}.ipolate(type=log) {%name}loglinear
' 3. Catmull Rom Spiline
	{%name}loglinear.ipolate(type=cr) {%name}catmull
' 4. Catmull Rom Spiline - multiplicativo
	{%name}loglinear.ipolate(type=Lcr) {%name}catmullm
' 5. Cardinal spiline
	{%name}.ipolate(type=cs, tension=0.1) {%name}cardinal
' 6. Cardinal spiline - multiplicativo
	{%name}.ipolate(type=lcs, tension=0.1) {%name}cardinalm
' 7. Cubic spiline
	{%name}.ipolate(type=cb) {%name}cubic
' 8. Cubic spiline - multiplicative
	{%name}.ipolate(type=lcb) {%name}cubicm
smpl 1960 1987
' Grupos
group series01 {%name}cardinal {%name}cardinalm {%name}catmull {%name}catmullm {%name}cubic {%name}cubicm {%name}linear {%name}loglinear {%name}
freeze(all_series) series01.line
' General average of series 
series {%name}average = ({%name}cardinal+ {%name}cardinalm+{%name}catmull +{%name}catmullm+{%name}cubic +{%name}cubicm+ {%name}linear +{%name}loglinear)/8
group series02 {%name} {%name}average
series02.line



stop
stop
stop
stop
stop
stop

wfcreate(wf=workfile, page=interpola) a 1950 2020 
rndseed 12345
series f = @trend + 2*nrnd
f.displayname Serie simulada
freeze(plot01) f.line
' --- --- ---
series f_ = f 
smpl 1955 1957
series f_ = NA
smpl 1960 1961
series f_ = NA
smpl 1950 2020
' --- --- ---
group series01 f f_
series01.line
' --- --- ---
' Mètodos de interpolacion
' Linear
f_.ipolate f_linear
' Log linear
f_.ipolate(type=log) f_loglinear
' Catmull Rom Spiline
f_loglinear.ipolate(type=cr) f_catmull
' Catmull Rom Spiline - multiplicativo
f_loglinear.ipolate(type=Lcr) f_catmullm
' Cardinal spiline
f_.ipolate(type=cs, tension=0.1) f_cardinal
' Cardinal spiline - multiplicativo
f_.ipolate(type=lcs, tension=0.1) f_cardinalm
f_.ipolate(type=lcs, tension=0.5) f_cardinal05m
f_.ipolate(type=lcs, tension=0.6) f_cardinal06m
f_.ipolate(type=lcs, tension=0.8) f_cardinal08m
' Cubic spiline
f_.ipolate(type=cb) f_cubic
' Cubic spiline - multiplicative
f_.ipolate(type=lcb) f_cubicm
group series02 F_CARDINAL F_CARDINALM F_CATMULL F_CATMULLM F_CUBIC F_CUBICM F_LINEAR F_LOGLINEAR F 
freeze(pool) series02.line
' Avergae
series f_avera = (F_CARDINAL+ F_CARDINALM +F_CATMULL +F_CATMULLM +F_CUBIC +F_CUBICM+ F_LINEAR +F_LOGLINEAR)/8
group series03 f f_avera
series03.line
series error = f - f_avera
error.line



