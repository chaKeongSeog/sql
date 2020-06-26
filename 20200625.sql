SELECT * | [컬럼명 ...]
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

null:아직 모르는 값 할당되지 않은값
null과 숫자타입의 0은 다르다
null과 문자타입의 공백과 다르다

null의 중요한 특징
null을 피연산자로하는 연산의 결과는 항상 null
null+500 = null

EMP테이블에서 SAL 컬럼과 COMM 컬럼의 합을 새로운 컬럼으로 표현
조회 컬럼은:empno,ename,sal,comm,sal컬럼과 comm컬럼의 합

ALLAS:컬럼이나 EXPRESSION에 새로운 이름부여
적용 방법:컬럼,EXPRESSION [AS] 별칭명
별칭을 소문자로 하고싶은경우 :별칭명을 더블 퀘테이션으로 묶는다 ""==>이걸로
SELECT empno,ename,sal,comm,sal+comm AS sal_plus_comm
FROM emp;
실습2
SELECT prod_id as id,prod_name as name
FROM prod;

SELECT lprod_gu AS gu,lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디,buyer_name AS 이름
FROM buyer;

literal : 값 자체를 의미
literal 표기법: 값을 표현하는 방법
ex: test라는 문자열을 표기하는 방법
java: System.out.println("test");
sql:'test' sql에서는 싱글 퀘테이션으로 문자열을 표기(''로 표현한다는 의미)
JAVA:String s = "test"
SQL:SELECT 'TEST' ....

java 대입연산자 : =
pl/sql 대입연산자: ;=
언어마다 연산자표기,literal 표기법이 다르기 때문에 해당 언어에서 지정하는 방식을 잘 따라야한다

문자열 연산:결합
일상 생활에서 문자열 결합 연산자는없다
java 문자열 결합 연산자 : +
sql에서 문자열 결합 연산자:||
users 테이블의 userid컬럼과 username컬럼을 결합
SELECT userid,usernm,userid || usernm AS id_name,concat(userid,usernm) AS concat_id_name
FROM users;
sql에서 문자열 결합 함수:concat(문자열1,문자열2) ==>문자열1 || 문자열2
두개의 문자어를 한자로 받아서 결합결과를 리턴

임의 문자열 결합:(sal+500,'아이디' || userid)

SELECT userid,'아이디' || userid
FROM users;

SELECT table_name
FROM user_tables;

SELECT 'SELECT * FROM ' ||table_name || ';' as name
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' AS name
FROM user_tables;
where 절:테이블에서 조회할 행의 조건을 기술
      where 절에서 기술한 조건이 참일때 행을 조회한다
      sql에서 가장 어려운 부분 많은 응용이 발생하는 부분
SELECT *
FROM users
where userid = 'brown';

emp테이블에서 deptno 컬럼의 값이 30보다 크거나 같은 행을 조회 컬럼은 모든컬럼
SELECT *
FROM emp
where deptno >= 30;

DATE 타입에 대한 WHER절 조건 기술
emp 테이블에서 hiredate 값이 1982 1월1일 이후인 사원들만 조회
sql에서 date 리터럴 표기법:'YY/MM/DD'
단 서버 설정마다 표기법이 다르다
한국:YY/MM/DD
미국:MM/DD/YY

'12/11/01' ==> 국가별로 다르게 해석이 가능하기때문에 DATE리터럴 보다는
문자열을 DATE타입으로 변경해주는 함수를 주로 사용
TO_DATE('날짜문자열','첫번째 인자의 형식')

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1980/01/01','YYYY/MM/DD');

BETWEEN AND :두 값 사이에 위치한 값을 참으로 인식
사용방법 비교값 BETWEEN 시작값 AND 끝값
비교값이 시작값과 종료값을 포함하여 사이에 있으면 참으로 인식

EMP테이블에서 SQL값이 1000보다 크거나겉고 2000보다 작거나 같은 사원들만 조회
SELECT *
FROM emp
WHERE sal between 1000 AND 2000;

SAL BETWEEN 1000 AND 2000를 부호로 나타내면?
SAL >= 1000 이면서 SAL <=2000

실습1
SELECT ename,hiredate
FROM emp
WHERE hiredate between TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD');
실습2
SELECT ename,hiredate
FROM emp
WHERE hiredate >=TO_DATE('1982/01/01','YYYY/MM/DD') AND hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');

IN연산자:비교값이 나열한값에 포함될때 참으로 인식
사용방법:비교값 IN (비교대상 값1,비교대상 값2,비교대상 값2)

사원의 소속 부서가 10번 혹은 20번인 사원을 조회하는 SQL을 IN 연산자로 작성
SELECT *
FROM emp
WHERE deptno IN(10,20);

IN연산자를 사용하지않고 OR연산을 통해서도 동일한 결과를 조회하는 SQL작성 가능
SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 20;



