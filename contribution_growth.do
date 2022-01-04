* Contrubución de los factores al crecimiento
* Penn World Tables

* Entorno de trabajo
clear all
cls 
global datadir "D:\Paulo Ramos\Nueva carpeta (3)\PIB potencial K L\EconomicGrowth-main\Economic-Growth stata" 

* Directorio de trabajo
*cd "D:\Paulo Ramos\Nueva carpeta (3)\PIB potencial K L\EconomicGrowth-main\Economic-Growth stata"

* Importación de base de datos
use "$datadir/pwt100.dta", clear 

* Codificamos la variable country de string a numérica (categórica)
encode country, generate(countryi)

* Para mostrar las etiquetas de los datos de los 183 países
label list countryi

* Set the panel data
xtset countryi year

* Gráfico de la tasa de depreciación de 6 países a partir del año 1990
*xtline delta if (countryi==22 | countryi==6 | countryi==25 | countryi==38 | countryi==42 | countryi==129) & (year>1990)

* Gráfico del PIB real para 4 países a partir del año 1990
*xtline rgdpna if (countryi==130) & (year>1990)

* Variables
*browse year rgdpna rnna emp avh labsh if (countryi==130) & (year>=1990)

* Generamos horas totales de trabajo por semana (L)
gen total_hours = emp*avh if (countryi==130) 

* El promedio de labor share el alpha y el de capital share beta
sum labsh if (countryi==130) 
*display a =  r(mean) 
scalar j =  r(mean) 
*-------------------------------------------*
egen alpha = mean(labsh) if (countryi==130) 
gen beta = 1 - alpha if (countryi==130) 
scalar alp = .5599701
scalar bet = .4400299  


* Calculamos la PTF Productividad total de factores
*gen A =  rgdpna/(((rnna)^(bet))*((total_hours)^(alp)))
gen A =  rgdpna/(((rnna)^(1-j))*((total_hours)^(j)))

* Entonces calculamos la contribución del trabajo, capital y TFP sobre el PIB
* Generamos los rezagos de las variables de interés
foreach i in rnna total_hours rgdpna {
	gen l_`i' = L.`i' if (countryi==130) 
}

*foreach n in rnna total_hours rgdpna {
*	gen `n'_g = (`n'/l_`n'-1)*100
*}
	gen y_c = (rgdpna/l_rgdpna-1)*100 if (countryi==130)
	gen k_c = (bet*(rnna/l_rnna-1))*100 if (countryi==130)
	gen l_c = (alp*(rgdpna/l_rgdpna-1))*100 if (countryi==130)


* Se obtiene la PTF por diferencia
gen A_c = y_c-k_c-l_c

br if countryi==130

*xtline y_c k_c A_c l_c if countryi==130

xtline y_c k_c A_c l_c if countryi==130 & year>=1990, recast(bar) lcolor(%30) byopts(title(Contribución de factores al crecimiento del PIB) subtitle(En puntos porcentuales (1950 - 2019)) caption(Elaboración: Unidad de Análisis y Estudios Fiscales) note(Fuente: Penn World Table))

graph export "D:\Paulo Ramos\Nueva carpeta (3)\PIB potencial K L\EconomicGrowth-main\Economic-Growth stata\Graph.png", as(png) name("Graph") replace

* keep te permite sólo manejar esos datos
*keep nr year lwage exper educ hours
