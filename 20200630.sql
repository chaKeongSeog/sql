날짜 관련 오라클 내장함수
내장함수:탑재가 되어있다는 의미
        오라클에서 제공해주는 함수(많이 사용하기때문)
MONTHS_BETWEEN(DATE11DATE2)    :두 날짜 사이의 개월수를 반환 ==> 값:1.212개월
ADD_MONTHS(date1,NUMBER):DATE 날짜에 NUMBER 만큼의 개월수를 더하고 뺀 날짜 반환
NEXT_DAY(date1,주간요일(1~7)):date1 이후에 등장하는 첫번째 주간요일의 날짜 변환
                            20200630,6 == >20200703 (20200630 이후의 첫번째 토요일)
LAST_DAY(date1):date1 날짜가 속한 월의 마지막 날짜 변환
                20200605==>20200630
                모든달의 첫번째 날짜는 1일로 정해져있음
                하지만 달의 마지막 날짜는 다른경우가 있다
                윤년의 경우:2월달이 29일이다
SELECT ename,TO_CHAR(hiredate,'YYYY-MM-DD') hiredate,
       MONTHS_BETWEEN(SYSDATE,hiredate)
FROM emp;       

ADD_MONTHS
SELECT ADD_MONTHS(SYSDATE,5) aft5,
       ADD_MONTHS(SYSDATE,-5) bft5
FROM dual;

NEXT_DAY:해당 날짜 이후에 등장하는 첫번째 주간 요일의 날짜
SYSDATE 이후에 등장하는 첫번째 토요일(7)은 몇일인가?
SELECT NEXT_DAY(SYSDATE,7)
FROM dual;

LAST_DAY:해당일자가 속한 열의 마지막 일자를 변환

SELECT LAST_DAY(TO_DATE('2020/06/05','YYYY/MM/DD'))
FROM dual;

LAST_DAY는 있는데 FIRST_DAY는 없다 ==>모든 열의 첫번째 날짜는? 동일 (1일)
FIRST_DAY 직접 SQL로 구현
SYSDATE:20200630 => 20200603
1.SYSDATE를 문자로 변경하는데 포맷은? YYYYMM
2.1번의 결과에다가 문자열 결합을 통해 '01'문자를 뒤에 붙여준다
  YYYYMMDD
3.2번의 결과를 날짜 타입으로 변경  

SELECT TO_DATE(CONCAT(TO_CHAR(SYSDATE,'YYYYMM'),'01'),'YYYYMMDD')
FROM dual;
 실습 154번 '201602' ==> 29 ,해당년월의 일수(마지막 날짜)==>LAST_DAY(날짜)
SELECT '201912' AS PARAM,TO_CHAR(LAST_DAY(TO_DATE('2019/12','YYYY/MM')),'DD') AS DT
FROM dual;

SELECT :param AS PARAM,TO_CHAR(LAST_DAY(TO_DATE(:param,'YYYY/MM')),'DD') AS DT
FROM dual;

실행 계획:DBMS가 요청받은 SQL을 처리하기위해 세운 절차
         SQL 자체에는 로직이 없다 어떻게 처리해라가없다 JAVA와 다른점
실행 계획 보는방법:
1.위에서 아래로
2.단 자식노드가 있으면 자식조드부터 읽는다
자식노드 :   들여쓰기가 된 노드
1.실행 계획을 생성
EXPLAIN PLAN FOR
실행계획을 보고자 하는 SQL:
2.실행계획을 보는 단계
SELECT *
FROM TABLE(dbms_xplan.display);

empno 컬럼은 NUMBER 타입이지만 형변환이 어떻게 일어났는지 확인하기 위해서
의도적으로 문자열 상수 비교를 진행
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR((empno) = '7369');

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69';

SELECT *
FROM TABLE(dbms_xplan.display);

형변환(NUMBER)
6,000,000 <==>6000000
국제화:i18n
날짜 국가별로 형식이 다르다
한국:yyyy-mm-dd
미국:mm-dd-yyyy

숫자
한국:9,000,000.00
독일:9.000.000,00

실습
sal(NUMBER):컬럼의 값을 문자열 포맷팅 적용
SELECT ename,sal,TO_CHAR(sal,'L9,999.00'),'L9,999.00'
FROM emp;

NULL과 관련된 함수:NULL 값을 다른값으로 치환 하거나 혹은 강제로 NULL로 만드는것
1.NVL(expr1,expr2) *이거 많이 사용
    IF(expr1 == null)
        return expr2;
    else
        return expr1;
SELECT empno,sal,comm,NVL(comm,0),
       sal+comm,sal+ NVL(comm,0)
FROM emp;

2.NVL2(expr1,expr2,expr3)
IF(expr1 != null)
    return expr2
else
    return expr3
    
SELECT empno,sal,comm,NVL2(comm,comm,0),
       sal+comm,sal+ NVL2(comm,comm,0),NVL2(comm,comm+sal,sal)
FROM emp;

3.NULLIF(expr1,expr2)
IF(expr1 == expr2)
    NULL 값 반환
else
    expr1을 반환
SELECT ename,sal,comm,NULLIF(sal,3000)
FROM emp;

4.COALLESCE(expr1,expr2......)
인자중에 가장 처음으로 null값이 아닌 값을 갖는 인자를 반환
COALLESCE(NULL,NULL,30,NULL,50)
IF(expr1 != null)
    return expr1;
else 
    COALLESCE(expr2....)    
    
SELECT COALESCE(NULL,NULL,30,NULL,50)
FROM dual;

NULL 처리 실습
emp테이블에 14명의 사원이 존재,한명을 추가(INSERT)

INSERT INTO emp(empno,ename,hiredate)
VALUES(9999,'brown',NULL);
조회컬럼:ename,mgr,mgr 컬럼값이 null이면 111로 치환한 값-null이 아니면 mgr 컬럼값,hiredate,hiredate가 null이면
sysdate 표기-null이 아니면 hiredate 컬럼값

SELECT ename,mgr,NVL(mgr,111),hiredate,NVL(hiredate,SYSDATE)
FROM emp;
실습 171번
SELECT empno,ename,mgr,NVL(mgr,9999) mgr_n,NVL2(mgr,mgr,9999) mgr_n_1,COALESCE(mgr,9999) mgr_n_2
FROM emp;
실습 172번
SELECT userid,usernm,reg_dt,NVL(reg_dt,SYSDATE)
FROM users;

SELECT (6/27) * 100 || '%'
FROM dual;

SQL 조건문
CASE
    WHERE 조건문(참 거짓을 판단할수있는 문장) THEN 변환할 값
    WHERE 조건문(참 거짓을 판단할수있는 문장) THEN 변환할 값2
    WHERE 조건문(참 거짓을 판단할수있는 문장) THEN 변환할 값3
    ELSE 모든 WHEN절을 만족시키지 못할때 반환할 기본 값
END -->하나의 컬럼으로 취급

emp테이블에 저장된 job 컬럼의 값을 기준으로 급여(sal)를 인상시키려고한다
sal컬럼과 함께 연상된 sal 컬럼의 값을 비교하고 싶은 상황
급여 인상 기준
job이 salesman 이라면 sal 1.05
job이 MANAGER 이라면 sal 1.10
job이 PRESIDENT 이라면 sal 1.20
나머지 기타 직군은 SAL로 유지

SELECT ename,job,sal,
       CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END inc_sal
FROM emp;
SELECT *
FROM emp
실습 177번
SELECT  empno,ename,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END dname
FROM emp 



