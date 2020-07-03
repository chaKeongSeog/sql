GROUP BY 함수의 특징
1.NULL은 그룹함수 연산에서 제외가 된다

부서번호별 사원의 sal,comm컬럼의 총 합을 구하기
SELECT deptno,SUM(sal+comm),SUM(sal)+SUM(comm),SUM(sal+NVL(comm,0))
FROM emp
GROUP BY deptno;

NULL 처리의 효율
SELECT deptno,SUM(sal)+NVL(SUM(comm),0),
              SUM(sal)+SUM(NVL(comm,0))
FROM emp
GROUP BY deptno;
실습 193번
SELECT MAX(sal),MIN(sal),ROUND(AVG(sal),2) avg_sal,SUM(sal),COUNT(sal),COUNT(mgr),COUNT(*)
FROM emp;
실습 194번 위에 코드를 부서별로 묶어서 조회
SELECT deptno,MAX(sal),MIN(sal),ROUND(AVG(sal),2) avg_sal,SUM(sal),COUNT(sal),COUNT(mgr),COUNT(*)
FROM emp
GROUP BY deptno;
실습 195번 위에 코드를 활용해서 deptno대신 부서명(dname)이 나오도록 해라
SELECT MAX(sal),MIN(sal),ROUND(AVG(sal),2) avg_sal,SUM(sal),COUNT(sal),COUNT(mgr),COUNT(*),
       CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            ELSE 'DDIT'
       END dname
FROM emp
GROUP BY deptno;
실습 196번
SELECT TO_CHAR(hiredate,'YYYYMM') hiredate,COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');
실습 197번
SELECT TO_CHAR(hiredate,'YYYY') hiredate,COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY');
실습 198번
SELECT COUNT(deptno) cnt
FROM dept;
실습 199번
SELECT COUNT(*) cnt
FROM(SELECT deptno
    FROM emp
    GROUP BY deptno);
다른 정답
SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno;

JOIM:컬럼을 확장하는 방법(데이터를 연결한다)
     다른테이블의 컬럼을 가져온다
RDBMS가 중복을 최소화하는 구조이기때문에
하나의 테이블에 데이터를 전부 담지않고,목적에맞게 설계한 테이블에 
데이터가 분산이된다
히자만 데이터를 조회 할때 다른 테이블의 데이터를 연결하여 컬럼을 가져올수있다

ANSI-SQL
ORACLE SQL 문법

JOIN:ANSI-SQL
     ORACLE-SQL의 차이가 다소 발생
     
ANSI-SQL JOIN
NATURAL JOIN:조인하고자 하는테이블간 컬럼명이 동일할 경우 해당 컬럼으로
             행을 연결
             컬럼 이름만 같은게 아니라 데이터 타입도 동일해야한다
믄법:
SELECT 컬럼...
FROM 테이블1 :NATURAL JOIN 테이블2

emp,dept:두 테이블의 공통된 이름을 갖는 컬럼:deptno

조인조건으로 사용된 컬럼은 테이블 한정자를 붙이면 에러[ansi-sql]
SELECT emp.empno,emp.ename,deptno,dept.dname
FROM emp NATURAL JOIN dept;

위에 쿼리를 ORACLE 버젼으로 수정
오라클에서는 조인조건을 WHERE절에 기술
행을 제한하는 조건,조인 조건 ==>WHERE절에 기술

SELECT emp.deptno,emp.*,job
FROM emp,dept
WHERE emp.deptno = dept.deptno;

ANSI-SQL:JOIN WITH USING
조인 테이블간 동일한 이름의 컬럼이 복수개인데
이름이 같은 컬럼중 일부로만 조인하고 싶을때
SELECT *
FROM emp JOIN dept USING(deptno);
위의 쿼리를 ORACLE 조인으로 변경하려면?
SELECT *
FROM emp,dept
WHERE emp.deptno = dept.deptno;

ANSI-SQL:JOIN WITH ON
위에서 배운 NATURAL JOIN,JOIN WITH USING의 경우 조인 테이블의 조인컬럼의
이름 같아야 한다는 제약조건이있음
설계상 두 테이블의 컬럼이름 다를수도 잇음,컬럼이름 다를 경우
계발자가 직접 조인 조건을 기술할수있도록 제공해주는 문법

SELECT *
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

ORACLE-SQL
SELECT *
FROM emp,dept
WHERE emp.deptno = dept.deptno

SELF-JOIN:동일한 테이블끼리 조인할때 지칭하는 명칭
          별도의 키워드가 아니다

SELECT 사원번호,사원이름,사원의 상사 사원번호,사원의 상사이름 //king은 상사가 없기떄문에 조인 실패 총 행의 수는 13
FROM emp;

SELECT e.empno,e.ename,e.mgr,m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

SELECT *
FROM emp

-- 12
사원중 사원의 번호가 7369~7699인 사원만 대상으로 해당 사원의
사원번호, 이름, 상사의 사원번호, 상사의 이름

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp  e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno >= 7369 AND e.empno <= 7699;

SELECT a.*, emp.ename
FROM (SELECT empno, ename, mgr
      FROM emp
      WHERE empno BETWEEN 7369 AND 7699) a, emp
WHERE a.mgr = emp.empno;

SELECT a.*, emp.ename
FROM (SELECT empno, ename, mgr
      FROM emp
      WHERE empno BETWEEN 7369 AND 7699) a JOIN emp ON (a.mgr = emp.empno);
      
NON-EQUI JOIN : 조인 조건이 =이 아닌조합
!= : 값이 다를떄 연결

-급여등급 salgrade는 중복되면 안됌
SELECT *
FROM salgrade;

SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;

-- 실습

SELECT empno, ename, emp.deptno, dname
FROM emp,dept
WHERE emp.deptno = dept.deptno;


SELECT a.*
FROM (SELECT empno, ename, emp.deptno, dname
      FROM emp, dept
      WHERE emp.deptno = dept.deptno) a
WHERE deptno IN(10,30);

SELECT empno, ename, emp.deptno, dname
FROM emp,dept
WHERE emp.deptno = dept.deptno
    AND emp.deptno IN(10,30);
실습 2번
SELECT emp.empno,emp.ename,emp.deptno,dept.dname
FROM emp,dept 
WHERE emp.deptno = dept.deptno
      AND sal > 2500
ORDER BY deptno;      
실습 3번
SELECT emp.empno,emp.ename,emp.sal,emp.deptno,dept.dname
FROM emp,dept
WHERE emp.deptno = dept.deptno
AND (sal > 2500 AND empno > 7600);
실습 4번
SELECT emp.empno,emp.ename,emp.sal,emp.deptno,dept.dname
FROM emp,dept
WHERE emp.deptno = dept.deptno
AND (emp.sal > 2500 AND emp.empno > 7600 AND dept.dname = 'RESEARCH');    
    
    
    

