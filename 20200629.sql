ROWNUM:SELECT 순서대로 행 번호를 부여해주는 가상컬럼
특징:where절에서 사용하는게 가능
    ***사용할수있는 형태가 정해져있음
    WHERE ROWNUM = 1;ROWNUM이 1일때
    WHERE ROWNUM <= (<) n; ROWNUM이 N보다 작거나 같은경우,작은경우
    WHERE ROWNUM BETWEEN 1 AND N; ROWNUM이 1보다 크거나 같고 N보다 작거나 같은경우
    
    ==>ROWNUM은 1부터 순차적으로 읽는 환경에서만 사용이 가능
    
    *****안되는경우
    WHERE ROWNUM = 2;
    WHERE ROWNUM >= 2;
    
ROWNUM 사용 용도:페이징 처리
페이징 처리:네이버 카페에서 게시글 리스트를 한화면에 제한적인 갯수로 조회(100)
           카페에 전체 게시글 수는 굉장히 많음
           ==>한 화면에 못보여줌 (1.웹브라우저가 버벅임2.사용자의 사용성이 굉장히 불편)
           ==>한페이지당 건수를 정해놓고 해당 건수만큼만 조회해서 화면에 보여준다

WHERE 절에서 사용할수있는 형태           
SELECT ROWNUM,empno,ename
FROM emp
WHERE ROWNUM <= 10;

WHERE 절에서 사용할수없는 형태           
SELECT ROWNUM,empno,ename
FROM emp
WHERE ROWNUM >= 10;

ROWNUM과 ORDER BY
SELECT SQL의 실행순서:FROM ==>WHERE ==>SELECT ==>ORDER BY

SELECT ROWNUM,empno,ename
FROM emp
ORDER BY ename;

ROWNUM의 결과를 정렬이후에 반영 하고싶은경우 ==> IN-LINE VIEW
VIEW:SQL DBMS에 저장되어있는 SQL
IN-LINE:직접 기술했다,어딘가 저장을한게 아니라 그 자리에 직접 기술

SELECT 절에 *만 단독으로 사용하지 않고 콤마를 통해 다른 임의 컬럼이나 expression을 표기한 경우 *앞에 
어떤 테이블(뷰)에서 온것인지 한 정자(테이블 이름,view 이름)을 붙여줘야한다

table,view 별칭:table이나 view에도 SELECT절의 컬럼처럼 별칭을부여 할수있다
                단 SELECT 절처럼 AS키워드는 사용하지않는다
                EX:FROM emp e
                FROM (SELECT empno,ename
                      FROM emp
                      ORDER BY ename) v_emp
SELECT emp.*
FROM emp;
아래 쿼리는 안된다 테이블 명이 없기때문에
SELECT ROWNUM,*
FROM(SELECT empno,ename
     FROM emp
     ORDER BY ename);
테이블 명을 붙여주면 가능
SELECT ROWNUM,a.*
FROM(SELECT empno,ename
     FROM emp
     ORDER BY ename) a;

아래는 가능한 경우이다
SELECT ROWNUM,empno,ename
FROM(SELECT empno,ename
     FROM emp
     ORDER BY ename);

요구사항:페이지당 10건의 사원 리스트가 보여야된다
페이지번호,페이지당 사이즈
1 page:1-10
2 page:11-20
3 page:21-30
*
*
*
n page:n * 10-9 ~n *10 ==>페이지가 10개인경우
    :(n-1) * 10 +1 ~ n *10
    
페이징 처리 쿼리 1 page:1-10
SELECT ROWNUM,a.*
FROM(SELECT empno,ename
     FROM emp
     ORDER BY ename) a
WHERE ROWNUM BETWEEN 1 AND 10;

페이징 처리 쿼리 2 page:11-20
SELECT ROWNUM,a.*
FROM(SELECT empno,ename
     FROM emp
     ORDER BY ename) a
WHERE ROWNUM BETWEEN 11 AND 20;

ROWNUM의 특성으로 1번부터 읽지않는 형태이기 때문에 정상적으로 동작하지 않는다

ROWNUM의 값을 별칭을 통해 새로운 컬럼으로 만들고 해당 SELECT SQL을 in-line view로 만들어
외부에서 ROWNUM에 부여한 별칭을 통해 페이징 처리를한다

페이징 처리 쿼리 2 page:11-20
SELECT *
FROM(SELECT ROWNUM AS rn,a.*
    FROM(SELECT empno,ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 20;

SQL 바인딩 변수:java 변수
페이지 번호:page
페이지 사이즈:pagesize
SQL 바인딩 변수 표기:변수명 ==>PAGE,PAGESIZE


바인딩 변수 적용 (PAGE-1) * PAGESIZE +1 ~ PAGE * PAGESIZE
SELECT *
FROM(SELECT ROWNUM AS rn,a.*
    FROM(SELECT empno,ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN (:page - 1) * :pageSize + 1 AND :page * :pageSize;

FUNCTION :입력을 받아들여 특정 로직을 수행후 결과값을 반환하는 객체
오라클에서의 함수구분:입력되는 행의 수에따라
1.SINGLE ROW FUNCTION
    :하나의 행이 입력되서 결과로 하나의 행이나온다
2.Multi ROW FUNCTION
    :여려개의 행이 입력되서 결과로 하나의 행이나온다

dual 테이블:oracle의 sys계정에 존재하는 하나의 행 하나의 컬럼을 갖는 테이블
            누구나 사용할수 있도록 권한이 개방됨
dual 테이블 용도
1.함수 실행(테스트)
2.시퀀스 실행
3.merge 구문
4.데이터 복제
SELECT *
FROM dual;

length 함수 테스트
SELECT LENGTH('TEST')
FROM dual;

문자열 관련 함수:설명은 pt 참고

SELECT CONCAT('Hello',CONCAT(', ','WORLD!')) concat,
       SUBSTR('Hello World',1,5) substr,
       INSTR('Hello , World','o') instr,
       LPAD('Hello World',15,' ') lpad,
       REPLACE('Hello World','o','p') replace,
       TRIM(' Hello World        ') trim,
       TRIM('d' FROM 'Hello World') trim,
       LOWER('Hello World') lower,
       UPPER('Hello World') upper,
       INITCAP('Hello World') initcap
FROM dual;

함수는 WHERE 절에서도 사용가능
사원 이름이 SMITH인 사람
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
위 두개의 쿼리중에서 하지 말아야할 형태는 아래꺼이다
밑에 형태:좌변을 가공하는 형태(좌변 - 테이블 컬럼을 의미)

오라클 관련 함수
ROUND(숫자,반올림 기준자리)
TRUNC(숫자,내림 기준자리)
MOD(피제수,제수):나머지 값을 구하는 함수

SELECT ROUND(105.54,1) round,
       ROUND(105.55,1) round2,
       ROUND(105.55,0) round3,
       ROUND(105.55,-1) round4,
       ROUND(105.55) round5
FROM dual

SELECT TRUNC(105.54,1) trunc,
       TRUNC(105.55,1) trunc2,
       TRUNC(105.55,0) trunc3,
       TRUNC(105.55,-1) trunc4,
       TRUNC(105.55) trunc5
FROM dual

sal을 1000으로 나눴을 때의 나머지 ==> mod함수 별도의 연산자는 없다
몫도 구하면
SELECT ename,sal,TRUNC(sal / 1000) MOK,mod(sal,1000) reminder
FROM emp;

날짜 관련 함수
sysdate:
오라클에서 제공해주는 특수함수
1.인자가없어
2.오라클이 설치된 서버의 현재 년,월,일,시,분,초 정보를 반환해주는 함수

SELECT SYSDATE
FROM dual;
도구/환경설정/데이터베이스/NLS/날짜형식/YYYY/MM/DD HH24:MI:SS

날짜타입 + 정수:정수를 일자취급,정수만큼 미래,혹은 과거 날짜의 데이트 값을 반환

EX:오늘 날짜에서 하루다한 미래 날짜 값은?
SELECT SYSDATE + 1
FROM dual;

ex:현재 날짜에서 3시간뒤 데이트를 구하려면?
데이트 + 정수(하루)
하루 == 24시간
1시간 == 1/24
3시간 == (/24) * 3== 3/24

1분: 1/24/60

3시간 뒤
SELECT SYSDATE + (1/24) * 3
FROM dual;

30분뒤
SELECT SYSDATE + (1/24/60) * 30
FROM dual;

데이트 표현하는 방법
1.데이트 리터링:NSL_SESSION_PARATER 설정에 따르기
            때문에 DBMS 환경마다 다르게 인식될 수 있음
2.문자열을 날짜로 변경해주는 함수:TO_DATE

실습 PPT 141번
SELECT TO_DATE('2019/12/31','YYYY/MM/DD'),TO_DATE('2019/12/31','YYYY/MM/DD') - 5,SYSDATE,SYSDATE - 3
FROM dual;

문자열 ==>데이트
TO_DATE('날짜 문자열','날짜 문자열의 패턴')
데이트 ==>문자열(보여주고 싶은 형식을 지정할때)
TO_CHAR(데이트 값,표현하고싶은 문자열 패턴)

SYSDATE 현재날짜를 년더4자리 월 2자리 일 2자리
SELECT SYSDATE,TO_CHAR(SYSDATE,'YYYY-MM-DD'),
        TO_CHAR(SYSDATE,'D'),
        TO_CHAR(SYSDATE,'IW')
FROM dual;


날짜 포맷:PT참고
YYYY
MM
DD
HH24
MI
SS

D,IW

SELECT ename,hiredate,TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') h1,
        TO_CHAR(hiredate + 1,'YYYY/MM/DD HH24:MI:SS') h2,
        TO_CHAR(hiredate + 1/24,'YYYY/MM/DD HH24:MI:SS') h3
FROM emp;
실습 145번
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE,'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;