create or replace table `DATATHON.PASSO_MAGICOS` AS 
with base as (
select  
NOME,
INSTITUICAO_ENSINO_ALUNO_2021,
TURMA_2021,
PEDRA_2021,
round(CAST (INDE_2021 as FLOAT64 ),1) INDE_2021,
IAA_2021,
IEG_2021,
IPS_2021,
IDA_2021,
IPP_2021,
PONTO_VIRADA_2021,
'2021-01-01' AS ANO 

from  `DATATHON.TbFiap2021`
where  INDE_2021 not in ('#NULO!')

union all  

select  
NOME ,
INSTITUICAO_ENSINO_ALUNO_2020,
 ' ' as TURMA_2020,
PEDRA_2020,
round(CAST (INDE_2020 as FLOAT64 ),1) INDE_2020,
round(CAST (IAA_2020 as FLOAT64 ) ,1)IAA_2020,
round(CAST (IEG_2020 as FLOAT64 ) ,1)IEG_2020,
round(CAST (IPS_2020 as FLOAT64 ) ,1)IPS_2020,
round(CAST (IDA_2020 as FLOAT64 ) ,1)IDA_2020,
round(CAST (IPP_2020 as FLOAT64 ) ,1)IPP_2020,
PONTO_VIRADA_2020,
'2020-01-01' AS ANO 
from  `DATATHON.TbFiap2020`
where  NOME not in ('ALUNO-1259')

union all

select  
NOME ,
' ' as INSTITUICAO_ENSINO_ALUNO_2022,
TURMA_2022,
PEDRA_2022,
INDE_2022,
round(IAA_2022,1) as IAA_2022 ,
round(IEG_2022,1) as IEG_2022 ,
round(IPS_2022,1) as IPS_2022 ,
round(IDA_2022,1) as IDA_2022 ,
round(IPP_2022,1) as IPP_2022 ,
PONTO_VIRADA_2022,
'2022-01-01' AS ANO 
from  `DATATHON.TbFiap2022`)

,BASE_FINAL AS (
select  a.*, b.*except(NomeAluno)    , c.ObservacaoRegistro , e.NomeDisciplina ,  
        CASE 
             WHEN  ANO = '2020-01-01'  THEN   DATE_DIFF( DATE(DATE_SUB(CURRENT_DATE() , INTERVAL 4 YEAR))  ,  DATE(DataNascimento),YEAR) 
             WHEN  ANO = '2021-01-01'  THEN   DATE_DIFF( DATE(DATE_SUB(CURRENT_DATE() , INTERVAL 3 YEAR))  ,  DATE(DataNascimento),YEAR) 
             WHEN  ANO = '2022-01-01'  THEN   DATE_DIFF( DATE(DATE_SUB(CURRENT_DATE() , INTERVAL 2 YEAR))  ,  DATE(DataNascimento),YEAR)  END IDADE 
from base  a 
     inner  join  `fiap-datalabs-projeto.DATATHON.TbAluno` b 
      on upper(a.NOME) = upper(replace(b.NomeAluno,' ','-'))
      left join  `fiap-datalabs-projeto.DATATHON.TbAlunoObs` c 
        on  b.IdAluno =  c.IdAluno
      left join  fiap-datalabs-projeto.DATATHON.TbSituacaoAlunoDisciplina d 
        on b.IdAluno = d.idAluno
      left  join  fiap-datalabs-projeto.DATATHON.TbDisciplina e
        on d.IdDisciplina = e.IdDisciplina
        WHERE  DataNascimento NOT  IN ('M'))
      

  SELECT  * , 
      CASE  
          WHEN  IDADE  <= 7  THEN  '01 - 7 Anos ou Menos'
          when  IDADE  BETWEEN  8 AND 10 then '02 - 8 a 10 Anos'  
          when  IDADE  BETWEEN  11 AND 12 then '03 - 11 a 12 Anos'  
          when  IDADE  BETWEEN  13 AND 14 then '04 - 13 a 14 Anos'  
          when  IDADE  BETWEEN  15 AND 16 then'05 - 15 a 16 Anos'  
          when  IDADE  BETWEEN  17 AND 18 then '06 - 17 a 18 Anos'  
           when  IDADE > 18 then '07 - Maor  18 Anos' end Faixa_idade

  FROM BASE_FINAL
































