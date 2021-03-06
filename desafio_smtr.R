install.packages("basedosdados")
library(basedosdados)
library(sqldf)
library(geosphere)
library(dplyr)


set_billing_id("dados-onibus")
query <- "SELECT * FROM `rj-smtr.br_rj_riodejaneiro_onibus_gps.registros_tratada` LIMIT 1000"

#download
dir <- tempdir()
data <- download(query, file.path(dir, "onibus.csv"))

#carregar o resultado da query
data <- read_sql(query)

#-------------------------------------------------------------
#como se trata de um dataset com quantidade espec�fica de posi��es (1000), 
#a ordena��o � computacionalmente menos custosa
ordem <- sqldf("SELECT ordem, timestamp_gps, latitude, longitude from data order by ordem, timestamp_gps")

#vari�veis criadas de coordenadas e somat�rios, 
#al�m do vetor que vai conter os c�lculos das velocidades resultantes (res[])
coord1 <- NULL
coord2 <- NULL

res <- NULL
res <- as.vector(res)
somadist <- 0
somatime <- 0

i <- 0
#estrutura de repeti��o para percorrer todas as posi��es
#at� 999 pois neste loop ser�o comparadas as ordens 999 e 1000
for (i in 1:999){
  #se a ordem atual for igual a ordem pr�xima, ent�o o c�lculo � realizado
  if (ordem$ordem[i] == ordem$ordem[i+1]){
    #calculo das coordenadas atrav�s da longitude e latitude 
    coord1 <- c(ordem$longitude[i], ordem$latitude[i])
    coord2 <- c(ordem$longitude[i+1], ordem$latitude[i+1])
    #dist�ncia de Haversine (em km)
    dist <- 0.001 * distHaversine(coord1, coord2, r=6378137)
    #tempo de percurso a partir do timestamp_gps
    tempo1 <- ordem$timestamp_gps[i]#i
    tempo2 <- ordem$timestamp_gps[i+1]#i+1
    #calculo da diferen�a de tempo
    time <- as.numeric(difftime(tempo2, tempo1, units = 'hours'))
    timeMin <- as.numeric(difftime(tempo2, tempo1, units = 'mins'))
    if (timeMin <= 10) {
      print("iftimeMin")
      if (ordem$ordem[i+2]==ordem$ordem[i]) {
        #se a ordem seguinte for igual as atuais, ent�o s�o somadas a dist�ncia e o tempo
        somadist <- somadist + dist
        somatime <- somatime + time
        #a posicao atual recebe NA pois o tempo � inferior a 10min e existe uma pr�xima posi��o
        res[i] <- NA
      } else {
        #caso a posi��o seguinte da ordem seja diferente, a velocidade � calculada
        velocidade <- (somadist/somatime)
        #vetor res[] recebe o resultado (velocidade)
        res[i] <- velocidade
        #os contadores de dist�ncia e tempo s�o zerados para a pr�xima ordem
        somadist <- 0
        somatime <- 0
      }
    }
    if (timeMin > 10) {
      #se o tempo � maior que 10 minutos, a velocidade � calculada diretamente
      velocidade <- (dist/time)
      res[i] <- velocidade
    }
  } else {
    #se as ordens s�o diferentes, nada � calculado
    res[i] <- NA
    
  }
  #vai para a pr�xima ordem
  i <- i+1
}

res[1000] <- NA
#dataframe contendo os resultados para todas as 1000 posi��es
return <- data.frame(NumOrdem = ordem$ordem, Velocidade = res)
#selecao do resultado das velocidades, exclu�ndo os NAs
resultado <- subset(return, (Velocidade != is.na(velocidade)), select=c(NumOrdem, Velocidade))
