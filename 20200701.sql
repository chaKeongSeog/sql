DECODE:조건에 따라 반환 값이 달라지는 함수
        ==>비교,JAVA(IT),SQL - CASE와 비슷
        단 비교연산이 =만 가능
        CASE의 WHEN절에 기술할수있는 코드는 참 거짓을 판단할수있는 코드면 가능
        EX:sal > 100
        이것과 다르게 decode함수에서는 sal = 1000,sal = 2000
DECODE는 가변인자(인자의 갯수가 정해지지않음 상황에따라 늘어날수도있다)를 갖는 함수
문법:DECODE(기준값[COLUMN]expression),
           비교값1,반환값1,
           비교값2,반환값2,
           비교값3,반환값4,
           옵션[기준값이 비교값중 일치하는 값이 없을때 기본적으로 반환할 값]
==>JAVA
IF(기준값 == 비교값)
    반환값을 반환해준다
ELSE IF(기준값 == 비교값2)
    반환값2
ELSE IF(기준값 == 비교값3)
    반환값3
ELSE
    마지막인자가 있을경우 마지막 인자를 반환하고
    마지막 인자가 없을경우 NULL을 반환

SELECT  empno,ename,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
FROM emp 

어제 작성한 위의 sql을 DECODE
SELECT empno,ename,DECODE(deptno,
                                 10,'ACCOUNTING',
                                 20,'RESEARCH',
                                 30,'SALES',
                                 40,'OPERTIONS',
                                 'DDIT')dname
FROM emp;

예시
SELECT ename,job,sal,
       CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END inc_sal
FROM emp;
위에 코드를 DECODE로 바꿔줘라
SELECT empno,ename,job,sal,DECODE(job,
                                     'SALESMAN',sal * 1.05,
                                     'MANAGER',sal * 1.10,
                                     'PRESIDENT',sal * 1.20,
                                     sal) inc_sal
FROM emp;                                     

위에 문제처럼 job에 따라서 sal을 인상을 한다
단 추가조건으로 job이 manager이면서 소속부서(deptno)가 30(sales)이면 sal * 1.5
SELECT ename,job,sal,deptno,
       CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN 
                                      CASE
                                            WHEN deptno = 30 THEN sal * 1.5
                                            ELSE sal * 1.1
                                      END
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END inc_sal
FROM emp;

위에 코드를 DECODE로 변경
SELECT empno,ename,sal,job,deptno,
       DECODE(job,
              'SALESMAN',sal * 1.05,
              'PRESIDENT',sal * 1.20,
              'MANAGER',DECODE(deptno,10,sal * 1.5,sal * 1.10),
              sal) inc_sal
FROM emp;

실습 178번 입사년도가 홀수년도라면 2019년은 홀수년도이다 그러면 건강검진대상이다
입사년도가 짝수이면 2019년도 건강검진대상아님
SELECT empno,ename,hiredate,
       CASE 
            WHEN mod(TO_CHAR(hiredate,'YY'),2) = mod(TO_CHAR(SYSDATE,'YY'),2) THEN '대상자'
            ELSE '비대상자'
       END contact_to_doctor
FROM emp;

실습 179번 USERS 테이블을 이용하여

SELECT userid,usernm,alias,reg_dt,
       CASE
            WHEN MOD(TO_CHAR(reg_dt,'YY'),2) = MOD(TO_CHAR(SYSDATE,'YY'),2) THEN '대상자' 
            WHEN TO_CHAR(reg_dt,'YY') = NULL THEN '비대상자'                                                      
            ELSE '비대상자'
       END contact_to_doctor
FROM users;
DECODE로 바꿔서 해라
SELECT userid,usernm,alias,reg_dt,
       DECODE(MOD(TO_CHAR(reg_dt,'YY'),2),
              MOD(TO_CHAR(SYSDATE,'YY'),2),'대상자',
              '비대상자') contact_to_doctor
FROM users;
SELECT *
FROM emp;

그룹함수:여러개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수
sum:합계
count:행의수
AVG:그룹의 평균값
MAX:그룹에서 가장 큰 값
MIN:그룹에서 가장 작은 값

사용방법
SELECT 행들을 묶을 기준,행들을 묶을기준2,그룹함수
FROM 테이블
[WHERE]
GROUP BY 행들을 묶을 기준,행들을 묶을기준2

예제 부서번호별 sal컬럼의 값 ==>부서번호가 같은 행들을 하나의 행으로 묶는다
SELECT deptno,sum(sal)
FROM emp
GROUP BY deptno;

예제 부서번호별 sal컬럼의 합,부서번호별 가장 큰 급여를 받는사람
SELECT deptno,SUM(sal),MAX(sal)
FROM emp
GROUP BY deptno;

예제 부서번호별 sal컬럼의 합,부서번호별 가장 작은 급여를 받는사람
SELECT deptno,SUM(sal),MIN(sal)
FROM emp
GROUP BY deptno;
예제 부서번호별 sal컬럼의 합,부서번호별 가장 작은 급여를 받는사람,부서번호별 평균 급여
SELECT deptno,SUM(sal),MIN(sal),ROUND(AVG(sal),2)
FROM emp
GROUP BY deptno;
예제 부서번호별 sal컬럼의 합,부서번호별 가장 작은 급여를 받는사람,부서번호별 평균,부서번호별 급여가 존재하는
사람의수(sal 컬럼이 null이 아닌 행의수,* :그 그룹의 행수)
SELECT deptno,SUM(sal),MIN(sal),ROUND(AVG(sal),2),COUNT(sal),COUNT(*)
FROM emp
GROUP BY deptno;

그룹 함수의특징:NULL값을 무시
30번 부서의 사원 6명중 2명은 COMM값이 NULL
SELECT deptno,SUM(comm)
FROM emp
GROUP BY deptno;

그룹함수의 특징2:GROUP BY 을 적용하여 여러행을 하나의 행으로 묶게되면은 
               SELECT 절에 기술할수잇는 컬럼이 제한됨
               ==>SEELCT절에 기술되는 일반 컬럼들은(그룹함수에 적용하지않은)
               반드시 GROUP BY 절에 기술되어야한다
               단 그룹핑에 영향을주지않는 고정된 상수,함수는 기술하는것이 가능하다
               
ename은 그룹화할수없어서 max 써줌
SELECT deptno,MAX(ename),SUM(sal)
FROM emp
GROUP BY deptno;
==>그룹함수 이해하기어려우면 엑셀에 데이터 그려라
그룹함수의 특징3:1.일반 함수를 WHERE 절에서 사용하는게 가능
               WHERE UPPER('smith') = 'SMITH';
               그룹함수의 경우 WHERE 절에서 사용하는게 불가능
               하지만 HAVING절에 기술하여 동일한 결과를 나타낼수있다
               
SUM(sal) 값이 9000보다 큰 행들만 조회               
SELECT deptno,SUM(sal)            
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;

위의 쿼리를 HAVING절 없이 SQL작성
SELECT *
FROM(SELECT deptno,SUM(sal) sum_sal
    FROM emp
    GROUP BY deptno)
WHERE sum_sal > 9000;    

SELECT 쿼리 문법 총정리
SELECT
FROM 
WHERE
GROUP BY
HAVING
ORDER BY

GROUP BY 절에 행을 그룹핑할 기준을 작성
EX:부서번호별로 그룹을 만들경우
    GROUP BY :deptno
전체행을 기준으로 그룹핑을 하려면 group by 절에 어떤 컬럼을 기술해야 할까?
emp테이블에 등록한 14명의 사원 전체의 급여 합계를 구하려면?==>결과는 1개의 행
==>group by절을기술하지 않는다
SELECT SUM(sal)
FROM emp;

GROUP BY 절에 기술한 컬럼을 SELECT절에 기술하지 않은경우는?
SELECT SUM(sal)
FROM emp
GROUP BY deptno;

그룹함수의 제한사항
부서번호별 가장 높은 급여를 받는 사람의 급여액
==>그사람이 누군지 알수없음 :해결방법(서브쿼리,분석함수)
SELECT deptno,MAX(sal)
FORM emp
GROUP BY deptno;

