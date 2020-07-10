UPDATE:실수값으로 업데이트 ==>서브쿼리 사용가능
INSERT INTO emp(empno,ename,job)
VALUES(9999,'brown','RANGER');

방금 입력한 9999번 사번번호를 갖는 사원의 deptno와 job컬럼의 값을
SMITH사원의 deptno와 job값으로 업데이트

UPDATE emp
SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
    job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;    

==> update쿼리1 실행할때 안쪽 select쿼리가 2개가 포함됨==>비효율적
    고정된 값을 업데이트 하는게 아니라 다른 테이블에 있는 값을 통해서 업데이트 할때
    비효율이 존재
    ==>merge 구문을 통해 보다 효율적으로 업데이트가 가능


DELETE 테이블의 행을 삭제할때 사용하는 SQL
    특정 컬럼만 삭제하는거는 UPDATE
    DELETE 구문은 행자체를 삭제할때
1.어떤 테이블에서 삭제할지
2.테이블의 어떤 행을 삭제 할지

문법
DELETE FROM 테이블명
WHERE 삭제할 행을 선택하는 조건;
예제
UPDATE 쿼리 실습시 9999번 사원을 등록함,해당 사원을 삭제하는 쿼리를 작성
DELETE FROM emp WHERE empno = 9999;

DELETE 쿼리도 SELECT 쿼리 작성시 사용한 WHERE절과 동일
서브쿼리 사용 가능
사원중에 mgr가 7698인 사원만 삭제

DELETE 
FROM emp
WHERE mgr in (SELECT mgr
             FROM  emp
             WHERE mgr = 7698);

ROLLBACK;

DBMS의 경우 데이터의 복구를 위해서
DML 구문을 실행할때마다 로그를 생성
대량의 데이터를 지울때는 로그기록도 부하가 되기때문에
개발환경에서는 테이블의 모든 데이터를 지우는 경우에 한해서
TRUNCATE TABLE 테이블명

로그를 남기지않고 빠르게 삭제가 가능하다
단 로그가 없기 때문에 복구가 불가능하다

emp테이블을 이용해서 새로운 테이블을 생성
CREATE TABLE emp_copy AS
SELECT *
FROM emp;

TRUNCATE TABLE emp_copy;
SELECT *
FROM emp_copy;


TRANSACTION;

레벨 0 ( = Read Uncommitted )

 - 트랜잭션에서 처리중인 / 아직 커밋되지 않은 데이터를 다른 트랜잭션이 읽는 것을 허용

 - Dirty Read, Non-repeatable Read, Phantom Read 현상 발생

 - 오라클은 이 레벨을 지원하지 않음



레벨 1 ( = Read Committed )

 - Dirty Read 방지 : 트랜잭션이 커밋되어 확정된 데이터만 읽는 것을 허용

 - 대부분의 DBMS가 기본모드로 채택하고 있는 일관성 모드

 - Non-Repeatable Read, Phantom Read 현상 발생

 - DB2, SQL Server, Sybase의 경우 읽기 공유 Lock을 이용해서 구현, 하나의 레코드를 읽을 때 Lock을 설정하고 해당 레코드에서 빠지는 순간 Lock해제

 - Oracle은 Lock을 사용하지 않고 쿼리시작 시점의 Undo 데이터를 제공하는 방식으로 구현



레벨 2 ( = Repeatable Read )

 - 선행 트랜잭션이 읽은 데이터는 트랜잭션이 종료될 때까지 후행 트랜잭션이 갱신하거나 삭제하는 것을 불허함으로써 같은 데이터를 두번 쿼리했을 때 일관성 있는 결과를 리턴

 - Phantom Read 현상 발생

 - DB2, SQL Server의 경우 트랜잭션 고립화 수준을 Repeatable Read로 변경하면 읽은 데이터에 걸린 공유 Lock을 커밋할 때까지 유지하는 방식으로 구현

 - Oracle은 이 레벨을 명시적으로 지원하지 않지만 for update절을 이용해 구현 가능,

   SQL Server등에서도 for update 절을 사용할 수 있지만 커서를 명시적으로 선언할 때만 사용 가능함



레벨 3 ( = Serializable Read )

 - 선행 트랜잭션이 읽은 데이터를 후행 트랜잭션이 갱신하거나 삭제하지 못할 뿐만 아니라 중간에 새로운 레코드를 삽입하는 것도 막아줌

 - 완벽한 읽기 일관성 모드를 제공


DML:데이터를 다루는 SQL
SELECT,INSERT,UPDATE,DELETE

DDL:데이터를 정의하는 SQL
DDL은 자동커밋,ROLLBACK QNFRK
ex:테이블 생성 DDL 실행 ==>롤백이 불가
    ==>테이블 삭제 DDL 실행
    
데이터가 들어갈 공간(TABLE) 생성,삭제
컬럼추가
각종 객체 생성,수정,삭제;

테이블 삭제
문법
DROP 객체 종류 객체이름;
DROP TABLE emp_copy;

SELECT *
FROM emp_copy;

DML문과 DDL문을 혼합해서 사용할 경우 발생할수 있는 문제점
==>의도와 다르게 DML문에 대해서 COMMIT할수있다
INSERT INTO emp(empno,ename)
VALUES(9999,'brown');

SELECT COUNT(*)
FROM emp;


DROP TABLE batch;


SELECT COUNT(*)
FROM emp;

SELECT COUNT(*)
FROM batch;

테이블 생성
CREATE TABLE 테이블명(
    컬럼명1 컬럼명1타입,
    컬럼명2 컬럼명2타입,
    컬럼명3 컬럼명3타입 DEFAULT 기본값,   
)
실습
RANGER라는 이름의 테이블 생성
CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE DEFAULT SYSDATE
)

INSERT INTO ranger(ranger_no,ranger_nm)
VALUES(100,'brown');

SELECT *
FROM ranger

데이터 무결성:잘못된 데이터가 들어가는 것을 방지하는 성격
ex:사원 테이블에 중복된 사원번호가 등록되는것을 방지
   반드시 입력이 되어야 되는 컬럼의 값을 확인
==>파일시스템이 갖을수 없는 성격

오라클에서 제공하는 데이터 무결성을 지키기위해 제공하는
제약조건:5가지
1.NOT NULL
    해당 컬럼에 값이 NULL 들어 오는것을 방지
    ex:emp 테이블의 empno컬럼
2.UNIQUE
    전체 행중에 해당컬럼의 값이 중복이 되면 안된다
    ex emp 테이블에서 empno컬럼이 중복되면 안된다
    단 null에대한 중복은 허용한다
     
3.PRIMARY KEY = UNIQUE+NOT NULL

4.FOREIGN KEY
    연관된 테이블에 해당 데이터가 존재해야만 입력이 가능
    emp테이블과 dept테이블은 deptno 컬럼으로 연결이 되어있음
    emp테이블에 데이터를 입력할때 dept테이블에 존재하지않는
    deptno 값을 입력하는것을 방지
==>emp테이블에 부서번호가 50번이면 X
    dept의 deptno는 10~40번까지 존재

5.CHECK 제약 조건
    컬럼에 들어오는 값을 정해진 로직에 따라 제어
    ex 어떤 테이블에 성별 컬럼이 존재하면
    남성 = a
    여성 = b
    성 컬럼은 a,b만 와야 저장될수있다
    만약 c라는 성별을 입력하면??
    시스템 요구사항을 정의할때 정의하지않은 값이기때문에 추후 문제가 될수도 있다
 
 제약조건 생성??
 1.테이블 생성시,컬럼 옆에 기술하는 경우
    * 상대적으로 세세하게 제어하는건 불가능
2.테이블 생성시,모든 컬럼을 기술하고나서
    제약조건만 별도로 기술
    1번 방법보다 세세하게 제어하는게 가능
3.테이블 생성이후
    객체 수정 명령을 통해 제약조건을 추가
 
 1번 방법 :테이블 생성
 PRIMARY KEY 생성
 dept 테이블과 동일한 컬럼명 ,타입으로 dept_copy 테이블 이름으로 생성
 
 DESC dept;
 CREATE TABLE dept_test(
    DEPTNO   NUMBER(2) PRIMARY KEY,
    DNAME     VARCHAR2(14) ,
    LOC       VARCHAR2(13) 
 );
 PRIMARY KEY 제약조건 확인
 UNIQUE+NOT NULL
 
 1.NULL값 입력 테스트
 INSERT INTO dept_test
 VALUES(NULL,'ddit','daejeon');
 
 2.값 중복 테스트
 INSERT INTO dept_test
 VALUES(99,'  ddit','daejeon');
 
 SELECT *
 FROM dept_test;
 
 첫번째 INSERT구문에의해 99번 부서는 dept_test 테이블에 존재
 deptno 컬럼의 값이 99번인 데이터가 이미 존재하기 때문에
 중복 데이터로 입력이 불가능
 INSERT INTO dept_test
 VALUES(99,'  ddit2','대전');
 
 현 시점에서 dept 테이블에는 deptno컬럼에 PRIMARY KEY 제약이 걸려있지 않은 상황
 SELECT *
 FROM dept;
 이미 존재하는 10번부서 추가로 등록
 INSERT INTO dept
 VALUES(10,'ddit','daejeon');
 
 
 테이블 생성시 제약조건 명을 설정한 경우
 DROP TABLE dept_test;
 컬럼명 컬럼 타입 CONSTRAINT 제약조건이름 제약조건타입[PRIMARY KEY]
 PRIMARY KEY 제약조건 명명 규칙:pk_테이블명 =>PRIMARY KEY_테이블명
 
  CREATE TABLE dept_test(
    DEPTNO   NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    DNAME     VARCHAR2(14) ,
    LOC       VARCHAR2(13) 
 );
 
  INSERT INTO dept_test
 VALUES(99,'  ddit','daejeon');
 
 SELECT * FROM dept_test;
 
  INSERT INTO dept_test
 VALUES(99,'  ddit2','대전');
 
 