zSELECT * | [컬럼명 ...]
FROM 테이블명;

SELECT *
FROM prod;

SELECT prod_id,prod_name
FROM prod;

/*
과제
*/
SELECT *
FROM lprod;

SELECT buyer_id,buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id,mem_pass,mem_name
FROM member;

expression:컬럼값을 가공을 하거나 존재하지않는 새로운 상수값(정해진 값)을 표현
        연산을 통해 새로운 컬럼을 조회할수있다
        연산을 하더라도 해당 sql조회 결과에만 나올뿐이고 실제 테이블의 데이터에는 영향을 주지않는다
        SELECT 구문은 테이블의 데이터에 영향을 주지않는다
        
         날짜 사칙연산:수학적으로 정의가 되어있지않음
         sql에서는 날짜데이터 => 정수를 일자 취급
         '2020년 6월 25일'+5 =>2020년 6월 25일부터 5일 지난 날짜
        데이터베이스에서 주로 사용하는 데이터 타입:문자,숫자,날짜
        empno:숫자
        ename:문자
        job:문자
        mgr:숫자
        hiredate:날짜
        sal:숫자
        comm:숫자
        테이블 컬럼구성 확인
        DESC 테이블명 (DESCRIBE 테이블명)
        DESC emp;
SELECT hiredate,hiredate+5,hiredate-5
FROM emp;

users 테이블의 컬럼 타입을 확인하고
reg_dt 컬럼 값에 5일뒤 날짜를 새로운 컬럼으로 표현
조회컬럼:userid,reg_dt,reg_dt 5일뒤 날짜

SELECT reg_dt,userid,reg_dt +5
FROM users;

SELECT *
FROM dept;


