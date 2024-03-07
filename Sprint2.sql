/* SPRINT 2
 NIVEL 1 
  EJERCICIO 1 
  Mostrar todas las trasacciones de empresas alemanas */

SELECT company_name as compañía, transaction.id as Id_transacción, timestamp as fecha, amount as cantidad, declined as realizada
FROM transaction
inner join company on company.id=transaction.company_id
WHERE company_id IN ( SELECT id
    FROM company
    WHERE country='Germany')
order by company_name;

/* EJERCICIO 2
   Márquetin está preparando algunos informes de cierres de gestión, 
 te piden que les pases un listado de las empresas que han realizado transacciones 
 por una suma superior a la media de todas las transacciones. */

select company.company_name as compañía
from company
inner join transaction on transaction.company_id=company.id
where declined = 0 and amount > (select avg(amount) from transaction)
group by company_name
order by company_name;

/* EJERCICIO 3
  El departamento de contabilidad perdió la información de les transacciones realizadas 
  per una empresa, pero no se recuerdan de su nombre, Sólo recuerdan que su nombre empezaba por la letra ‘c’. 
 ¿Cómo puedes ayudarles? Coméntalo acompañándolo de la información de las transacciones. */

select company.company_name as compañía, 
transaction.id as id_transacción, 
transaction.timestamp as fecha, 
amount as cantidad, 
declined as realizada
from transaction 
inner join company on company.id=transaction.company_id
where company_name like 'c%'
order by company_name;

/* EJERCICIO 4
  Van a eliminar del sistema las empresas que no tienen transacciones registradas. 
 Entrega el listado de estas empresas */

select company.company_name as compañía, count(transaction.id) as transacciones
from company
inner join transaction on transaction.company_id=company.id
where not exists (select transaction.id from transaction)
group by compañía
order by transacciones;

-- El resultado es negativo. Todas las empresas tienen transacciones registradas



