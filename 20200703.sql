실습 220번 erd 프로그램 참고하여 prod,lprod 테이블의 컬럼을 조회해라(pt 참고)
SELECT lprod_gu,lprod_nm,prod_id,prod_name
FROM prod,lprod
WHERE prod.prod_lgu = lprod.lprod_gu

다른버젼
ANSI-SQL 두 테이블 연결 컬럼명이 다르기 때문에 NATURAL JOIN,JOIN WITH USING은 사용이 불가
SELECT lprod_gu,lprod_nm,prod_id,prod_name
FROM prod join lprod ON(prod_lgu = lprod_gu)
실습 2 221번 
SELECT buyer_id,buyer_name,prod_id,prod_name
FROM buyer,prod
WHERE buyer.buyer_id = prod.prod_buyer;

ANSI-SQL 버젼
SELECT buyer_id,buyer_name,prod_id,prod_name
FROM buyer join prod ON(buyer.buyer_id = prod.prod_buyer);

실습 3 222번 
SELECT mem_id,mem_name,prod_id,prod_name,cart_qty
FROM member,cart,prod
WHERE member.mem_id = cart_member
AND cart.cart_prod = prod.prod_id
ANSI-SQL 버젼
SELECT mem_id,mem_name,prod_id,prod_name,cart_qty
FROM member JOIN cart ON( member.mem_id = cart_member)
            JOIN prod ON(cart.cart_prod = prod.prod_id);

SELECT *
FROM customer
WHERE cid = 1
고객

SELECT *
FROM product; 제품

SELECT *
FROM cycle;//고객 제품 애음 추가
실습 4번 224번
SELECT customer.cid,cnm,pid,day,cnt
FROM customer,cycle
WHERE customer.cid = cycle.cid
AND customer.cnm IN('brown','sally');
실습 5번 225번       
SELECT customer.cid,cnm,pnm,day,cnt
FROM customer,cycle,product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
AND customer.cnm IN('brown','sally');
실습 6번 226번

SELECT customer.cid,cnm,CYCLE.PID,PNM,SUM(cycle.cnt)
FROM customer,cycle,product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY customer.cid,customer.cnm,CYCLE.PID,PNM

실습 7번 227번

SELECT cycle.pid,PNM,SUM(cnt)
FROM cycle JOIN product ON(cycle.pid = product.pid)
GROUP BY cycle.pid,PNM

조인 성공 여부로 데이터 조회를 결정하는 구분방법
INNER JOIN:조인에 성공하는 데이터만 조회하는 조인 방법
OUTER JOIN:조인에 실패 하더라도 개발자가 지정한 기준이 되는 테이블의
            데이터는 나오도록하는 조인
OUTER <==> INNER JOIN

복습-사원의 관리자 이름을 알고싶은 상황
조회 컬럼:사원의 사번,사원의 이름,사원의 관리자이름,사원의 관리자의 이름

동일한 테이블끼리 조인이 되었기때문에 :SELF JOIN
조인 조건을 만족하는 데이터만 조회되었기 때문에 :INNER JOIN
SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp e,emp m
WHERE e.mgr = m.empno;

KING의 경우 PRESIDENT이기 때문에 mgr 컬럼의 값이 NULL ==>조인에 실패
==>KING의 데이터는 조회되지않음(총 14건 데이터중 13건의 데이터만 조인 성공)

OUTER 조인을 이용하여 조인 테이블중 기준이되는 테이블을 선택하면
조인에 실패하더라도 기준 테이블의 데이터는 조회되도록 할수있다
ANSI-SQL
테이블1 JOIN 테이블2 ON(.....)
테이블1 LEFT OUTER JOIN 테이블2 ON(.....)
위 쿼리는
테이블1 RIGHT OUTER JOIN 테이블1 ON(.....)

맨 마지막 KING은 NULL인데도 조회
SELECT e.empno,e.ename,m.empno,m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);
