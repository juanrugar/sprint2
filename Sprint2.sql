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

/* NIVEL 1
  EJERCICIO 2
   Márquetin está preparando algunos informes de cierres de gestión, 
 te piden que les pases un listado de las empresas que han realizado transacciones 
 por una suma superior a la media de todas las transacciones. */

select company.company_name as compañía
from company
inner join transaction on transaction.company_id=company.id
where declined = 0 and amount > (select avg(amount) from transaction)
group by company_name
order by company_name;

/* NIVEL 1 
  EJERCICIO 3
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

/* NIVEL 1 
  EJERCICIO 4
  Van a eliminar del sistema las empresas que no tienen transacciones registradas. Entrega el listado de estas empresas */

select company.company_name as compañía, count(transaction.id) as transacciones
from company
inner join transaction on transaction.company_id=company.id
where not exists (select transaction.id from transaction)
group by compañía
order by transacciones;

/* NIVEL 2 
  EJERCICIO 1 
  En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias 
  para hacer la competencia a la compañía Non Institute. 
  Por eso, te piden la lista de todas las transacciones realizadas 
  por empresas que están situadas en el mismo país que esta compañía.
  */
  
select company.company_name as compañía, 
transaction.id as id_transacción, 
transaction.credit_card_id as id_tarjeta,
transaction.company_id as id_compañía,
transaction.user_id as id_usuario,
transaction.timestamp as fecha,
amount as cantidad, 
declined as realizada
from transaction 
inner join company on company.id=transaction.company_id
where company.country in (select country from company where company_name = 'Non Institute')
order by company_name;

/* NIVEL 2
 EJERCICIO 2
 El departamento de contabilidad necesita que encuentres la empresa 
 que ha realizado la transacción de mayor suma en la base de datos.
*/

select company.company_name as compañía, (select max(transaction.amount) from transaction) as mayor_cantidad
from company
inner join transaction on company.id=transaction.company_id
where transaction.amount = (select max(transaction.amount) from transaction)
group by compañía;

/* NIVEL 3
 EJERCICIO 1 
 Se están estableciendo los objetivos de la empresa para el próximo trimestre, 
 por lo que necesitan una base sólida para evaluar el rendimiento y medir el éxito en los diferentes mercados. 
 Para eso, necesitan el listado de los países cuya media de transacciones sea superior a la media general.
*/

select company.country País, 
(select count(transaction.id) / (select count(distinct company.id))) as Media_Transacciones_nacionales
from company
inner join transaction on company.id=transaction.company_id
group by País
having Media_Transacciones_nacionales >  (select count(transaction.id) from transaction) / (select count(distinct company.id) from company) 
order by Media_Transacciones_nacionales desc;

/*  NIVEL 3
 EJERCICIO 2
 Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
 por lo cual te piden la información sobre la cantidad de transacciones que realizan las empresas, 
 pero el departamento de de recursos humanos es exigente 
 y quieren un listado de las empresas dónde especifiques si tiene más de 4 transacciones o menos.
*/

select company_name as compañía, count(transaction.id) as Total_transacciones,
case
	when count(transaction.id) < 4 then "Menos de cuatro transacciones"
    when count(transaction.id) > 4 then "Más de cuatro transacciones"
end as N_transacciones
from transaction 
inner join company on company.id=transaction.company_id
group by company_name
order by Total_transacciones desc, N_transacciones;