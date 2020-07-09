1.GROUP BY 여러개의 행을 하나의 행으로 묶는 행위
2.JOIN
3.서브쿼리
    1.사용위치
    2.변환하는행,컬럼의개수
    3.상호연관/비상호연관
        =>메인쿼리의 컬럼을 서브쿼리에서 사용하는지 유뮤에 따른분류
            1.비상호 연관,서브쿼리의 경우 단독으로 실행가능
            2.상호연관 서브쿼리의 경우 실행하기위해서 메인쿼리의 컬럼을 사용하기때문에 단독으로 실행이 불가능
            
사원들의 급여 평균보다 높은급여를 받는 직원
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);
==>비상호

사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원정보 조회
참고,스칼라 서브쿼리를 이용해서 해당사원이 속한 부서의 부서이름을 가져오도록 작성
SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal) 
                FROM emp s
                WHERE s.deptno = e.deptno);

전체사원의 정보를 조회,조인없이 해당사원이 속한 부서의 부서이름 가져오기
SELECT empno,ename,deptno,(SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp

실습 SMITH나 WARD사원이 속한 부서의 모든사원정보를 조회
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename ='SMITH'
                OR ename ='WARD');
단일 비교는 = 
복수행비교는 IN

IN과 NOT IN이용시 NULL값의 존재 유무에따라 원하지 않는 결과가 나올수도 있다
NULL과 IN,NULL과 NOT IN
IN==>OR
NOT IN ==> AND
WHERE mgr IN(7902,null)
==>mgr =7908 OR null
==>mgr값이 7902 이거나 [mgr값이 null인 데이터]
SELECT *
FROM emp
WHERE mgr IN(7902,null);

WHERE mgr NOT IN(7902,null)
==>NOT(mgr = 7902 OR mgr = null)
==>mgr != 7902 AND mgr != null)

pairwise,non-pairwase
한행의 컬럼 값을 하나씩 비교하는것:non-pairwase
SELECT *
FROM emp
WHERE job IN('MANAGER','CLERK')

한행의 복수컬럼 값을 하나씩 비교하는것:pairwase
SELECT *
FROM emp
WHERE (job,deptno) IN(('MANAGER',20),('CLERK',20));

non-pairwase 예제
7698,30
7698,10
7839,10
7839,30
SELECT *
FROM emp
WHERE (mgr,deptno) IN(SELECT mgr,deptno
                      FROM emp
                      WHERE empno IN(7499,7782));

pairwase 예제
7698,30
7839,10
SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
                      FROM emp
                      WHERE empno IN(7499,7782))
AND deptno IN (SELECT deptno
                      FROM emp
                      WHERE empno IN(7499,7782));    
                      
실습 행 삽입
INSERT INTO dept VALUES(99,'ddit','daejeon')                      

SELECT *
FROM dept
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);    
실습 sub5
SELECT *
FROM product
           
SELECT *
FROM cycle
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1)
실습 SUB6
SELECT *
FROM cycle
WHERE cid = 1
AND pid  IN (SELECT pid
             FROM cycle
             WHERE cid = 2)