시도,시군구별,햄버거 도시발전지수==>(kfc+버거킹+맥도날드/롯데리아)

한행에 다음과 같이 컬럼이 구성되면 공식을 쉽게 적용할수있다

시도,시군구,kfc개수 버거킹개수 맥도날드 개수 롯데리아 개수

주어진것:점포하나하나의 주소
1.시도,시군구,프렌차이즈 별로 group by * 1
    1.시도,시군구,kfc 개수
    2.시도,시군구,버거킹 개수
    3.시도,시군구,맥도날드 개수
    4.시도,시군구,롯데리아 개수

4개의 데이터 셋을 이용해서 컬럼 확장이 가능==>join
시도,시군구, 같은 데이터끼리 조인

2.시도,시군구,프렌차이즈 별로 group by * 2
    1.시도,시군구,분자 프렌차이즈 합 개수
    2.시도,시군구,분자 프렌차이즈(롯데리아) 합 개수
3.2개의 데이터 셋을 이용해서 컬럼 확장 ==>join
    시도 시군구 같은데이터끼리 조인

3.모든 프렌차이즈를 한번만 읽고서 처리하는 방법
    1.fastfood 테이블의 한행은 하나의 프렌차이즈에 속함
    2.가상의 컬럼을 4개를 생성
        1.해당 row가 kfc면
        2.해당 row가 맥도날드이면
        3.해당 row가 버거킹이면
        4.해당 row가 롯데리아이면
        5.과정에서 생성된 컬럼 4개중에 같이 존재하는 컬럼은 하나만 존재함
        6.하나의 행은 하나의 프렌차이즈의 주소를 나타내는 점보
        7.시군구 별로 2-2과정에서 생성한 컬럼을 더하면 우리가 구하고자하는 프렌차이즈별 건수가 된다
        
SELECT sido,sigungu,SUM(DECODE(gb,'KFC',1))+SUM(DECODE(gb,'버거킹',1))+SUM(DECODE(gb,'맥도날드',1))/SUM(DECODE(gb,'롯데리아',1))
FROM fastfood
WHERE gb IN('KFC','버거킹','맥도날드','롯데리아')
GROUP BY sido,sigungu

SELECT sido,sigungu,ROUND(NVL(SUM(DECODE(storecategory,'KFC',1)),0)+
                          NVL(SUM(DECODE(storecategory,'BURGER KING',1)),0)+
                          NVL(SUM(DECODE(storecategory,'MACDONALD',1)),0) 
                          /NVL(SUM(DECODE(storecategory,'LOTTERIA',1)),1),2) score
FROM burgerstore
WHERE storecategory IN('KFC','BURGER KING','MACDONALD','LOTTERIA')
GROUP BY sido,sigungu

순위,햄버거발전지수 시도,햄버거발전지수 시군구,햄버거 발전지수,근로소득순위,
근로소득 시도,근로소득 시군구,1인당 근로소득

같은순위끼리 하나의 행에 데이터가 보여지도록

SELECT *
FROM tax

SELECT *
FROM burgerstore;

SELECT burger.*,tax.*
FROM 
(SELECT ROWNUM rn,sido,sigungu,score
FROM(SELECT sido,sigungu,ROUND(NVL(SUM(DECODE(storecategory,'KFC',1)),0)+
                                      NVL(SUM(DECODE(storecategory,'BURGER KING',1)),0)+
                                      NVL(SUM(DECODE(storecategory,'MACDONALD',1)),0) 
                                      /NVL(SUM(DECODE(storecategory,'LOTTERIA',1)),1),2) score
            FROM burgerstore
            WHERE storecategory IN('KFC','BURGER KING','MACDONALD','LOTTERIA')
            GROUP BY sido,sigungu
            ORDER BY score DESC)) burger,
(SELECT ROWNUM rn,sido,sigungu,tax
FROM (SELECT sido,sigungu,ROUND(sal / people,2) tax
        FROM tax
        ORDER BY tax DESC)) tax            
WHERE burger.rn(+) = tax.rn       
ORDER BY tax.rn;

CROSS JOIN:테이블간 조인 조건을 기술하지않는 형태로 두 테이블의 행간 모든 가능한 조합으로 조인이되는형태
            크로스 조인의 조회결과를 필요로하는 메뉴는 거의없다
            SQL 중간단계에서 필요한경우는 존재 ==>묻지마 조인
emp:14
dept:4
원래 하던것:emp에 있는 부서번호를 이용하여 dept에 있는 dname,loc컬럼을 가져오는것

SELECT e.empno,e.ename,e.deptno,d.dname,d.loc
FROM emp e CROSS JOIN dept d


CROSS 쓰지않아도 가능함
ANSI-SQL
SELECT e.empno,e.ename,e.deptno,d.dname,d.loc
FROM emp e JOIN dept d ON(1=1)


ORACLE-SQL
SELECT e.empno,e.ename,e.deptno,d.dname,d.loc
FROM emp e,dept d

customer,product의 모든가능한경우를 조인해서 조회해라
SELECT *
FROM customer,product   //컬럼 12개
SELECT *
FROM product    //컬럼 4개
SELECT *
FROM customer   //컬럼 3개
SMITH 사람이 속한부서에 속하는 사원들은 누구잇을까?
1.SMITH가 속한 부서의 번호를확인하는 쿼리
2.1번에서 확인한 부서번호로 해당 부서에 속하는 사원들을 조회

1.
SELECT *
FROM emp
WHERE ename = 'SMITH'

2.
SELECT *
FROM emp
WHERE deptno = 20
SMITH 사람이 현재 속한 부서는 20번인데
나중에 30번 부서로 부서전배가 이뤄지면
2번에서 작성한 쿼리가 수정이 되어야한다
WHERE deptno = 20 ==> WHERE deptno = 30

우리가 원하는 것은 고정된 부서번호로 사원 정보를 조회하는것이 아니라
smith가 속한 부서를 통해 데이터를 조회 ==>smith가 속한 부서가 바뀌더라도
쿼리를 수정하지 않도록 하는것

위에서 작성한 두개의 쿼리를 하나로 합칠수있다
==>SMITH의 부서번호가 바뀌더라도 우리가 원하는 데이터 셋을
    쿼리 수정없이 조회할수있다 ==>코드 변경이 필요없다==>유지보수가 편하다
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename='SMITH');
서브쿼리 SQL내부에서 사용된 SQL(Main 쿼리에서 사용된 쿼리)
사용위치 따른 분류
1.SELECT 절:sclar(단일의) subquery
2.FROM 절:INLINE-VIEW
3.WHERE 절:subquery

반환하는 행,컬럼 수에 따라 분류
1.단일행,단일 컬럼
2.단일행,복수 컬럼
3.다중행,단일 컬럼
4.다중행,복수 컬럼

서브쿼리에서 메인쿼리의 컬럼을 사용유무에따른 분류
1.서브쿼리에서 메인 쿼리의 컬럼사용:correlated subquery==>상호 연관 서브쿼리
            ==>서브쿼리 단독으로 실행하는것이 불가능
2.서브쿼리에서 메인 쿼리의 컬럼 미사용:non correlated subquery==>비상호 연관 서브쿼리
            ==>서브쿼리 단독으로 실행하는것이 가능
1.스칼라 서브쿼리:SELECT 절에서 사용된 서브쿼리
:제약사항 :반드시 서브쿼리가 하나의 행,하나의 컬럼을 반환해야한다

스칼라 서브쿼리가 단일행 복수 컬럼을 리턴하는경우(X)
SELECT empno,ename, (SELECT * FROM dept WHERE deptno = 10)
FROM emp

스칼라 서브쿼리가 단일행 단일 컬럼을 리턴하는경우(o)
SELECT empno,ename, 
            (SELECT deptno FROM dept WHERE deptno = 10) deptno,
            (SELECT dname FROM dept WHERE deptno = 10) dname
FROM emp;
메인 쿼리의 컬럼을 사용하는 스칼라
SELECT empno,ename, deptno,(SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;

IN-LINE-VIEW:그동안에 많이 사용

subquery:where절에서 사용된것
WHERE 절에서 주의할점
연산자와 서브쿼리의 반환 행수 주의
= 연산자를 사용시 서브쿼리에서 여러개 행을 리턴하면 논리적으로 맞지가 않다
IN 연산자를 사용시 서브쿼리에서 여러개 행과 비교가 가능
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename IN('SMITH','ALLEN') );
==>서브쿼리가 여러개의 행을 조회해서 안됨
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN('SMITH','ALLEN') );
실습 평균 급여보다 높은 급여를 받는 직원의 수
1.평균을 구해준다
2.평균보다 높은 사람의 수를 조회한다
3.1,2를 합쳐준다

SELECT COUNT(*)
FROM emp
WHERE sal >(SELECT AVG(SAL)
            FROM emp);
