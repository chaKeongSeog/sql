GROUPING[column]:0
0:컬럼이 소계계산에 사용 되지않았다 GROUP BY 사용 되었다
1:컬럼이 소계 계산에 사용되었다

SELECT NVL(job,'총계') job,deptno,GROUPING(job),GROUPING(deptno),SUM(sal)
FROM emp    
GROUP BY ROLLUP(job,deptno);

=>JOB컬럼이 소계계산으로 사용되어 NULL값이 나온것인지
정말 컬럼의 값이 NULL인 행들이 GROUP BY 된것인지
알려면 GROUPING 함수를 사용해야 정확한 값을 알수잇다
SELECT DECODE(GROUPING(job),1,'총계',job) job,deptno,GROUPING(job),GROUPING(deptno),SUM(sal)
FROM emp    
GROUP BY ROLLUP(job,deptno);

NVL 함수를 사용하지않고 GROUPING 함수를 사용해야하는 이유

GROUP BY job,mgr
GROUP BY job
GROUP BY 전체

SELECT job,mgr,GROUPING(job),GROUPING(mgr),SUM(sal)
FROM emp
GROUP BY ROLLUP(job,mgr);
예제
SELECT DECODE(GROUPING(job),1,'총',job) job,
        CASE
            WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '계'
            WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN '소계'
            WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 0 THEN TO_CHAR(deptno)
        END deptno,SUM(sal) sum
FROM emp
GROUP BY ROLLUP(job,deptno);
내가 푼거
SELECT DECODE(GROUPING(job),1,'총',job) job,NVL(DECODE(GROUPING(job),1,'계',deptno),'소계') deptno,GROUPING(job),GROUPING(deptno),SUM(sal) sum
FROM emp
GROUP BY ROLLUP(job,deptno);

정답
SELECT DECODE(GROUPING(job),1,'총',job) job,DECODE(GROUPING(job)+GROUPING(deptno),0,TO_CHAR(deptno),
                                                                                     1,'소계',
                                                                                     2,'계',deptno) deptno,GROUPING(job),GROUPING(deptno),SUM(sal) sum
FROM emp
GROUP BY ROLLUP(job,deptno);

예제
SELECT *
FROM emp

SELECT DECODE(e.deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES',null) dname,e.job,SUM(e.sal+NVL(e.comm,0)) sal
FROM emp e JOIN dept d ON(e.deptno = d.deptno)
GROUP BY ROLLUP(e.deptno,e.job)

예제
SELECT NVL(DECODE(e.deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES',null),'총합') dname,e.job,SUM(e.sal+NVL(e.comm,0)) sal
FROM emp e JOIN dept d ON(e.deptno = d.deptno)
GROUP BY ROLLUP(e.deptno,e.job)

확장된 GROUP BY
1.ROLLUP -컬럼 기술에 방향성이 존재
    GROUP BY ROLLUP(job,deptno) != GROUP BY ROLLUP(deptno,job)
    GROUP BY job,deptno         GROUP BY deptno,job
    GROUP BY job                GROUP BY deptno
    GROUP BY ''                 GROUP BY ''
    단점:개발자가 필요가 없는 서브 그룹을 임의로 제거할수없다
    
2.GROUP BY SETS -필요한 서브그룹을 임의로 지정하는 형태
==>복수의 GROUP BY 를 하나로 합쳐서 결과를 돌려주는 형태

    GROUP BY GROUPING SETS(col1,col2)
    GROUP BY col1
    UNION ALL
    GROUP BY col2

    GROUPING SETS의 경우 ROLLUP과는 다르게 컬럼 나열순서가 데이터자체에 영향을 미치지않음

    GROUP BY col1,col2
    UNION ALL
    GROUP BY col1
    
    ==>GRPUPING SETS((col1,col2),col1)




GROUPING SETS실습
SELECT job,deptno,SUM(sal+NVL(comm,0))
FROM emp
--GROUPING ROLLUP(job,deptno);
GROUP BY GROUPING SETS(job,deptno)
실습
SELECT job,deptno,mgr,SUM(sal+NVL(comm,0)) sal_sum
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr);

3.CUBE 
GROUP BY 를 확장한 구문
cube절에 나열한 가능한 조합으로 서브그룹을 생성
GROUP BY CUBE(job,deptno);
GROUP BY job,deptno;
GROUP BY job;
GROUP BY        deptno;
GROUP BY  

SELECT job,deptno,SUM(sal+NVL(comm,0)) sum_sal
FROM emp
GROUP BY CUBE(job,deptno);

CUBE의 경우 기술한 컬럼으로 모든 가능한 조합으로 서브그룹을 생성한다.
가능한 서브그룹은 2*기술한 컬럼개수
기술한 컬럼이 3개만 넘오도 생성되는 서브그룹의 개수가 8개가 넘기때문에
실제 필요하지않은 서브그룹이 포함될 가능성이 높다
==>ROLLUP,GROUP BY SETS보다 활용성이 떨어진다

중요한내용은아님
GROUP BY job,ROLLUP(deptno),DUBE(mgr)
==>내가 필요로하는 서브그룹을 GROUPING SETS를통해 정의하면 간단하게 작성가능

SELECT job,deptno,mgr,SUM(sal+NVL(comm,sal))
FROM emp
GROUP BY job,ROLLUP(deptno),CUBE(mgr)

SELECT job,deptno,mgr,SUM(sal+NVL(comm,sal))
FROM emp
GROUP BY job,ROLLUP(job,deptno),CUBE(mgr);

1.서브그룹 나열하기

2.엑셀에 1번의 서브그룹별로 색상을 칠해보자

emp_test 삭제
emp 테이블을 이용하여 emp_test테이블을 생성 
emp_test 테이블에 danme(VARCHAR2(14))컬럼 추가


DROP TABLE emp_test

CREATE TABLE emp_test AS
SELECT *
FROM emp
WHERE 1 = 1

ALTER TABLE emp_test ADD(dname VARCHAR2(14))

WHERE 절이 존재하지않음
UPDATE emp_test
SET  dname =(SELECT dname FROM dept WHERE dept.deptno = emp_test.deptno);

SELECT *
FROM emp_test;

실습
1.dept_test 삭제
2.dept 테이블을 이용하여 dept_test생성
3.dept_test 테이블에 empcnt(number)컬럼을 추가
4.subquery를 이용하여 dept_test 테이블의 empcnt컬럼을 해당 부서원수로 update를 실행

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 =1 

ALTER TABLE dept_test ADD(empcnt NUMBER(1));

SELECT (SELECT COUNT(*) FROM emp WHERE deptno = dept_test.deptno)
FROM dept_test

UPDATE dept_test 
SET empcnt = (SELECT COUNT(*) FROM emp WHERE deptno = dept_test.deptno);



