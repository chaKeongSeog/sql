오라클 객체
table-데이터 저장공간
    1.ddl:생성,수정,삭제
    2.view-sql(쿼리) 논리적인 데이터 정의,실체가 없다
        구성하는 테이블의 데이터가 변경되면 view결과도 달라진다
    3.sequence 중복되지않는 정수값을 반환해주는 객체
                유일한 값이 필요할때 사용할수있는 객체
                nextval,currval
    4.index-테이블의 일부 컬럼을 기준으로 미리 정렬해 놓은 데이터                
            테이블 없이 단독적으로 생성 불가,특정 테이블에 종속
            table 삭제를 하면 관련 인덱스도 같이 삭제
    DB구조에서 중요한 전제조건
    1.DB에서 I/O의 기준은 행단위가 아니라 BLOCK단위
    한건의 데이터를 조회하더라도 해당행이 존재하는 BLOCK전체를 읽는다
    데이터 접근 방식
    1.table full access
        multi block io ==>읽어야할 블럭을 여러개를 한번에 읽어들이는 방식
        
    2.index 접근,index접근후 table access
    single block io ==>읽어야할 행이 있는 데이터 block만 읽어서 처리하는 방식
    소수의 몇건 데이터를 사용자가 조회 할경우,그리고 조건에 맞는 인덱스가 존재할경우
    빠르게 응답을 받을수 있다
    하지만 single block io가 빈번하게 일어나면 multi block io보다 오히려 느리다
                            (일반적으로 8~16 block)
                            
    사용자가 원하는 데이터의 결과가 table의 모든 데이터를 다 읽어야 처리가 가능한 경우
    ==>인덱스 보다 여러 블럭을 한번에 많이 조회하는 table full access방식이 유리 할수잇다
    ex:
    전제 조건은 mgr,sal,comm 컬럼으로 인덱스가 없을때
    mgr,sal,comm 정보를 table에서만 획득이 가능할때
    SELECT COUNT(mgr),SUM(sal),SUM(comm),AVG(sal)
    FROM emp;
    
    3.extent 공간할당 기준
    
    현재 상태
    인덱스:IDX_NU_emp_01 [empno]
    
emp 테이블의 job 컬럼 기준으로 2번째 NON-UNIQUE 인덱스 생성
CREATE INDEX idx_nu_emp_02 ON emp(job);

현재상태
인덱스:idx_nu_emp01 (empno),idx_nu_emp_02 ON emp(job)
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

SELECT *
FROM emp
ORDER BY job;

인덱스 추가 생성
emp, 테이블의 jon,ename컬럼으로 복합 non-unique index 생성
idx_nu_emp_03
CREATE INDEX idx_nu_emp_03 ON emp(job,ename);
현재상태
인덱스:idx_nu_emp01 (empno),idx_nu_emp_02 ON emp(job),idx_nu_emp_03(job,ename)



EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

SELECT job,ename,ROWID
FROM emp
ORDER BY job,ename;


현재상태
인덱스:idx_nu_emp01 (empno),idx_nu_emp_02 ON emp(job),idx_nu_emp_03(job,ename)

위에 쿼리와 변경된 부분은 like 패턴이 변경
LIKE 'C%'; ==>LIKE '%C';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

인덱스 추가
emp 테이블에 ename,job 컬럼을 기준으로 non-unique 인덱스 생성(idx_nu_emp_04)
CREATE INDEX idx_nu_emp_04 ON emp(ename,job);

현재상태
인덱스:idx_nu_emp01 (empno),idx_nu_emp_02 ON emp(job),idx_nu_emp_03(job,ename),idx_nu_emp_04(ename,job)
:복합 컬럼의 인덱스의 컬럼순서가 미치는 영향



SELECT ename,job,rowid
FROM emp
ORDER BY ename,job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename  LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

3번째 인덱스 idx_nu_emp_03(job,ename) 삭제해봄
DROP INDEX idx_nu_emp_03;

SELECT ename,job,rowid
FROM emp
ORDER BY ename,job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename  LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

조인에서의 인덱스 활용
emp:pk_emp,fk_emp_dept 생성
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY(deptno) REFERENCES dept(deptno);

접근 방식:emp 1.table full access  2.인덱스 * 4: 방법 5가지 존재
         dept:1.table full access 2.인덱스 * 1 :방법 2가지 존재
         가능한 경우의 수가 10가지
         방향성 emp,dept를 먼저 처리할지 ==>20
         
EXPLAIN PLAN FOR         
SELECT *
FROM emp,dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);


실습
테이블 생성
CREATE TABLE DEPT_TEST_2 AS
SELECT *
FROM dept
WHERE 1 = 1

인덱스 생성 unique (deptno 기준)
CREATE INDEX idx_u_dept_test_2_01 ON dept_test_2(deptno);

인덱스 생성 non-unique (dname기준)
CREATE INDEX idx_nu_dept_test_2_02 ON dept_test_2(dname);

인덱스 생성 non-unique (deptno,dname기준)
CREATE INDEX idx_nu_dept_test_2_03 ON dept_test_2(deptno,dname);

실습 2
DROP INDEX idx_nu_dept_test_2_01;
DROP INDEX idx_nu_dept_test_2_02;
DROP INDEX idx_nu_dept_test_2_03;

실습 3
CREATE UNIQUE INDEX idx_u_emp_01 ON emp(empno);
empno(=)
CREATE INDEX idx_nu_emp_02 ON emp(ename);
ename(=)
CREATE INDEX idx_nu_emp_03 ON emp(deptno,empno);
deptno(=),empno(LIKE) 선행조건은 =이 오는게 좋다 그다음 LIKE
CREATE INDEX idx_nu_emp_04 ON emp(deptno,sal);
deptno(=) sal(BETWEEN) =이 먼저 그다음 between
CREATE INDEX idx_nu_emp_05 ON emp(deptno,empno);
deptno(=) empno(=)
CREATE INDEX idx_nu_emp_06 ON emp(deptno,hiredate);
deptno(=) hiredate(=)
==> deptno,hiredate 컬럼으로 구성된 인덱스가 있을경우 table 접근이 필요없음

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM TABLE(dbms_xplan.display);

------------------------------------------------------------
SYNONYM:오라클 객체 별칭을 생성
cks.v_emp =>v_emp

생성 방법
CREATE [PUBLIC] SYNONYM 시노님 이름 FOR 원본 객체이름;

PUBLIC :모든 사용자가 사용할수있는 시노님
권한이 있어야 생성가능
PRIVATE  [DEFAULT]:해당 사용자만 사용 가능

삭제방법
DROP SYNONYM 시노님 이름;



