SQL 응용 :DML SELECT,UPDATE,INSERT,MERGE

1.MULTIPLE INSERT ==>많이 쓰이지는 않는다
한번의 INSETRT 구문을 통해 여러테이블에 데이터를 입력
RDBMS :데이터의 중복 최소화
실 사용예 : 1.실제 사용할 테이블과 별개로 보조테이블에도 동일한 데이터 쌓기
           2.데이터의 수평분할 (*)
           주문 테이블
           2020년 데이터 ==>TB_ORDER_2020
           2021년 데이터 ==>TB_ORDER_2021
           ==> 오라클 PARTITION을 통해 더 효과적으로 관리 가능(정식버전)
           하나의 테이블안에 데이터 값에따라 저장하는 물리공간이 나뉘어 져있음
           1.개발자 입장에서는 데이터를 입력하면
           데이터 값에 따라 물리적인 공간을 오라클이 알아서 나눠서 저장
           
MULTIPLE INSERT 종류
1.UNCONDITIONAL INSERT  조건과 관게없이 하나의 데이터를 여러테이블 입력
2.CONDITIONAL ALL INSERT 조건에 만족하는 모든 테이블에 입력
3.CONDITIONAL FIRST INSERT 조건에 만족하는 첫번째 테이블에 입력

실습
emp_test, emp_test2 DROP
emp테이블의 empno 컬럼이랑 ename컬럼만 갖고 emp_test,emp_test2를 생성
데이터는 복사하지않음

DROP TABLE emp_test;
DROP TABLE emp_test2;

CREATE TABLE emp_test2 AS
SELECT empno,ename
FROM emp
WHERE 1 != 1;

unconditional insert
아래 두개의 행을 emp_test,emp_test2에 동시 입력 하나의 insert 동시 입력
하나의 insert 구문 사용

INSERT ALL
    INTO emp_test VALUES(empno,ename)
    INTO emp_test2(empno) VALUES(empno)
SELECT 9999 empno,'brown' ename FROM dual
UNION ALL
SELECT 9999 empno,'sally' ename FROM dual;
    
    
SELECT *
FROM emp_test

rollback;
조건 분기:CASE WHEN THEN END
조건 분기 함수:DECODE
2.conditional insert
INSERT ALL
    WHEN empno >= 9999 THEN
        INTO emp_test VALUES(empno,ename)
    WHEN empno >= 9998 THEN
        INTO emp_test2 VALUES(empno,ename)    
    ELSE
        INTO emp_test2(empno) VALUES(empno)
SELECT 9999 empno,'brown' ename FROM dual
UNION ALL
SELECT 9998 empno,'sally' ename FROM dual;


rollback;
ALL=>3,FIRST=>?
3.conditional first insert
INSERT FIRST
    WHEN empno >= 9999 THEN
        INTO emp_test VALUES(empno,ename)
    WHEN empno >= 9998 THEN
        INTO emp_test2 VALUES(empno,ename)    
    ELSE
        INTO emp_test2(empno) VALUES(empno)
SELECT 9999 empno,'brown' ename FROM dual
UNION ALL
SELECT 9998 empno,'sally' ename FROM dual;

SELECT *
FROM emp_test

SELECT *
FROM emp_test2

merge 중요
사용자로부터 받은 값을 갖고
테이블 저장 or 수정
입력받은값이 테이블에 존재하면 수정을 하고싶고
입력받은값이 테이블에 존재하지않으면 신규입력을 하고싶을때

ex:empno,9999,ename 'beown'
emp테이블에 동이한 empno가 있으면 ename을 업데이트
emp테이블에 동일한 empno가 없으면 신규입력

미지구문을 사용하지 않는다면
1.해당 데이터가 존재하는지 확인하는 SELECT 구문을 실행
    1번쿼리가 조회 결과잇으면 UPDATE
    1번 쿼리의 조회결과 없으면 INSERT
2.테이블의 데이터를 이용하여 다른 테이블의 데이터를 업데이트 OR INSERT 하고 싶을때
    ALLLEN의 JOB과 DEPTNO를 SMITH사원과 동일한 업데이트 하시오
    UPDATE emp 
    SET job = (SELECT job FROM emp WHERE ename = 'SMITH'),
        deptrno = (SELECT deptno FROM emp WHERE ename = 'SMITH');
    WHERE ename = 'ALLEN';     
실습
1.    
SELECT *
FROM emp
WHERE empno = 9999

2.UPDATE emp SET ename = 'brown'
  WHERE empno = 9999;
  
3.INSERT INTO emp(empno,ename) VALUES(9999,'brown');  

문법
merge into 테이블명 (덮어쓰거나,신규로 입력할 테이블 ) ALIAS
USING(테이블명 | view |inline-view) alias
    ON(두 테이블간 데이터 존재 여부를 확인할 조건)
WHERE MATCHED THEN
    UPDATE SET 컬럼1 = 값1,
               컬럼2 = 값2
WHEN NOT MATCHED THEN                
    INSERT (컬럼1,컬럼2...) VALUES(값1,값2)

ROLLBACK;
1.7369 사원의 데이터를 emp_test로 복사(empno,ename)
    emp => emp_test
INSERT INTO emp_test    
SELECT empno,ename
FROM emp
WHERE empno = 7369;

emp:14 emp_test:1(7369-emp 테이블에도 존재)

emp테이블을 이용해서 emp_test에 동일한 empno값이 있으면
emp_test.ename 업데이트 없으면 emp 테이블의 데이터를 신규입력

MERGE INTO emp_test a
USING emp b
    ON(a.empno = b.empno)
WHEN MATCHED THEN 
    UPDATE 
    SET a.ename = b.ename || '_m'
WHEN NOT MATCHED THEN
    INSERT VALUES(b.empno,b.ename);
    
SELECT *
FROM emp_test;

emp_test 테이블에는
7369사원의 이름이 smith_m으로 업데이트
7369를 제외한 13명의 사원이 insert

merge에서 많이 사용하는 형태
사용자로부터 받은 데이터를 emp_test테이블에
동일한 데이터 존재 유무에 따른 merge
시나리오:사용자 입력 empno =9999,ename=brown


MERGE INTO emp_test a
USING dual
    ON(a.empno = :empno)
WHEN MATCHED THEN
    UPDATE 
    SET ename=:ename
WHEN NOT MATCHED THEN
    INSERT VALUES(:empno,:ename);
    
실습 :dept 테이블을 이용하여 dept_test3 테이블에 데이터를 merge
merge 조건:부서번호가 같은 데이터
    동일한 부서가 있을때 :기존 loc컬럼의 값+_m로 업데이트
    동일한 부서가 없을때:신규데이터 입력
    
SELECT *
FROM dept_test3

MERGE INTO dept_test3 a
USING dept d
    ON(a.deptno = d.deptno)
WHEN MATCHED THEN
    UPDATE SET a.loc = d.loc ||'_m'
WHEN NOT MATCHED THEN
    INSERT VALUES(d.deptno,d.dname,d.loc);
    
실습2 사용자 입력받은 값을 이용한 MERGE
    사용자 입력:deptno:9999,dname:'ddit' loc:'daejeon'
    dept_test3 테이블에 사용자가 입력한 deptno값과
    동일한 데이터 있을경우:사용자가 입력한 danme,loc값으로 두개 컬럼 업데이트
    동일한 데이터 없을경우 :사용자가 입력한 deptno,dname,loc값으로 insert
    
SELECT 9999,'ddit','daejeon'
FROM dual;

SELECT *
FROM dept_test3;

MERGE INTO dept_test3 a
USING dual d
    ON(a.deptno = :deptno)
WHEN MATCHED THEN 
    UPDATE 
    SET a.dname = :dname,
    a.loc = :loc
WHEN NOT MATCHED THEN
    INSERT VALUES(:deptno,:dname,:loc);


GROUP BY 응용,확장
실습 
SELECT null,SUM(sal)
FROM emp
UNION
SELECT deptno,ROUND(AVG(sal)) sal
FROM emp
GROUP BY deptno

실습
emp 테이블을 한번만 읽고서 처리하기
SELECT deptno,SUM(sal)
FROM emp
GROUP BY ROLLUP(deptno)


ROLLUP:GROUP BY 의 확장 구문
            1.정해진 규칙으로 서브 그룹을 생성하고 생성된 서브 그룹을
            2.하나의 집합으로 반환
            3.GROUP BY ROLLUP(col1,col2.....)
            4.ROLLUP 절에 기술된 컬럼을 오른쪽에서 부터 하나씩 제거해 가며
            
            GROUP BY ROLLUP(job,deptno)
            GROUP BY ROLLUP(deptno,job)
            ROLLUP의 경우 방향성이 있기 때문에 컬럼 기술순서가 다르면
            다른결과가 나온다
            
            서브 그룹을 생성
예시:GROUP BY ROLLUP(deptno)            
1.GROUP BY deptno 부서번호별
2.GROUP BY '' ==>전체 총계

예시
GROUP BY ROLLUP (job,deptno)
1.GROUP BY job,deptno ==>담당업무 부서번호별 총계
2.GROUP BY job ==>담당업무별 총계
GROUP BY '' ==>전체 총계

ROLLUP를 n개 사용 했을때 SUBGROUP의 개수는?n+ 1개의 서브 그룹이 생성

SELECT job,deptno,GROUPING(job),GROUPING(deptno),SUM(sal+NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job,deptno);

3개의 서브 그룹이 형성
job,deptno
job
''

SELECT DECODE(GROUPING(job),1,'총계',job) job,deptno,GROUPING(job),GROUPING(deptno),SUM(sal)
FROM emp    
GROUP BY ROLLUP(job,deptno);