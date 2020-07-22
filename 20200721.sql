UPDATE dept_test 
SET empcnt = (SELECT COUNT(*) FROM emp WHERE deptno = dept_test.deptno);

확장된 GROUP BY
==>서브그룹을 생성
만약 이런구문이 없다면 개발자가 직접 SELECT 쿼리를 여러개 작성해서 
UNION ALL을시행 ==>동일한 테이블을 여러번 조회 ==>성능저하
1.ROLLUP
    ROLLUP절에 기술한 컬럼을 오른쪽에서 부터 지워나가며 서브그룹을 생성
    생성되는 서브그룹:ROLLUP절에 기술한 컬럼개수+
    ROLLUP절에 기술한 컬럼의 순서가 결과에 영향을 미친다
    
GROUPING SETS
    사용자가 원하는 서브그룹을 직접 지정하는 형태
    컬럼 기술의 순서는 결과 집합에 영향을 미치지 않음(집합)
    
CUBE
    CUBE절에 기술한 컬럼의 가능한 모든 조합으로 서브그룹을 생성
    잘안쓴다 서브그룹이 너무 많이 생성됨
        cube절에 기술한 컬럼개수
        
SELECT *
FROM dept_test;
    
INSERT INTO dept_test VALUES(99,'ddit1','daejeon');    
INSERT INTO dept_test VALUES(98,'ddit2','daejeon');    

상호 연관
DELETE FROM dept_test d
WHERE deptno NOT IN (SELECT deptno
                FROM emp
                WHERE deptno = d.deptno)
비상호 연관
DELETE FROM dept_test
WHERE deptno NOT IN (SELECT deptno
                FROM dept_test
                WHERE deptno IN(SELECT deptno
                                    FROM emp));
상호 연관 EXISTS 로 풀기
DELETE FROM dept_test d
WHERE NOT EXISTS (SELECT 'X'
                FROM emp
                WHERE deptno = d.deptno)
실습
CREATE TABLE emp_test AS

SELECT *
FROM emp_test

UPDATE emp_test e
SET sal = sal+200
WHERE sal <(SELECT AVG(sal)
            FROM emp_test
            WHERE deptno = e.deptno)

WITH:쿼리 블럭을 생성하고
같이 실행되는 SQL에서 해당 쿼리 블럭을 반복적으로 사용할때 성능 향상 효과를 기대할수있다
WITH절에 기술된 쿼리 블럭은 메모리에 한번만 올리기 때문에
쿼리에서 반복적으로 사용하더라도 실제 데이터를 가져오는 작업은 한번만 발생

하지만 하나의 쿼리에서 동일한 서브쿼리가 반복적으로 사용된다는것은 쿼리를 잘못 작성할
가능성이 높다는 뜻이므로 WITH절로 해결하기 보다는 쿼리를 자른방식으로 작성할수없는지
먼저 고려해볼것을 추천

회사의 DB를 다른 외부인에게 오픈할수 없기때문에 외부인에게 도움을 구하고자 할때
테이블을 대신할 목적으로 많이 사용

사용방법:쿼리 블럭은 콤마를 통해 여러개를 동시에 선언하는것도 가능
WITH 쿼리블럭이름 AS(
    SELECT 쿼리
)
SELECT *
FROM 쿼리 블럭이름;

WITH T AS

202007 달력 만들기
1.2020년 7월의 일수 구하기

SELECT *
FROM dual
CONNECT BY LEVEL <= (SELECT TO_CHAR(LAST_DAY(TO_DATE('202007','YYYYMM')),'DD')
                    FROM dual);
202006 달력 만들기
1.2020년 6월의 일수 구하기

SELECT *
FROM dual
CONNECT BY LEVEL <= (SELECT TO_CHAR(LAST_DAY(TO_DATE('202006','YYYYMM')),'DD')
                    FROM dual);
202002 달력 만들기
1.2020년 2월의 일수 구하기

SELECT MAX(DECODE(d,1,dt)) sun,MAX(DECODE(d,2,dt)) mon,MAX(DECODE(d,3,dt)) tus,MAX(DECODE(d,4,dt)) wen,
            MAX(DECODE(d,5,dt)) the,MAX(DECODE(d,6,dt)) fri,MAX(DECODE(d,7,dt)) sat
FROM 
(SELECT  TO_DATE(:YYYYMM,'YYYYMM')+(level - 1) dt,
        TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM')+(level - 1),'D') d,
        TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM')+(level - 1),'IW') iw
FROM dual
CONNECT BY LEVEL <= (SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')),'DD')
FROM dual))
GROUP BY DECODE(d,1,iw+1,iw)
ORDER BY DECODE(d,1,iw+1,iw);

실습
SELECT NVL(SUM(DECODE(mm,01,sales)),0) jan,
       NVL(SUM(DECODE(mm,02,sales)),0) feb, 
       NVL(SUM(DECODE(mm,03,sales)),0) mar, 
       NVL(SUM(DECODE(mm,04,sales)),0) apr, 
       NVL(SUM(DECODE(mm,05,sales)),0) may, 
       NVL(SUM(DECODE(mm,06,sales)),0) jun
FROM(SELECT TO_CHAR(dt,'MM') mm,sales
    FROM sales
    GROUP BY dt,sales);























