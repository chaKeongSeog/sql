실습 6번
SELECT *
FROM cycle 
WHERE cid = 1
AND pid IN (SELECT pid
           FROM cycle
           WHERE cid = 2)
실습 7번
SELECT c.cid,m.cnm,c.pid,p.pnm,c.day,c.cnt
FROM cycle c,customer m,product p
WHERE c.cid = 1
AND  m.cid = c.cid
AND c.pid = p.pid
AND c.pid IN(SELECT c.pid
           FROM cycle c
           WHERE c.cid = 2)

SELECT *
FROM customer

SELECT *
FROM product

1.요구사항을 만족시키는 코드를 작성

1.5.테스트,중간점검

2.코드를 깨끗하게 ==>리팩토링(코드 동작은 그대로 유지한채 깔끔하게 정리하는거)

EXISTS 연산자:서브쿼리에서 반환하는 행이 존재하는지 체크하는 연산자
             서브쿼리에서 반환하는 행이 하나로도 존재하면 TRUE
             서브쿼리에서 반환하는 행이 존재하지않으면 FALSE
특이점 :1.WHERE 절에서 사용
       2.MAIN 테이블의 컬럼이 항으로 사용되지 않음
       3.비상호 연관서브쿼리,상호연관서브쿼리 둘다 사용 가능하지만
        주로 상호연관 서브쿼리[확인자]와 사용된다
       4.서브쿼리의 컬럼값은 중요하지 않다
        ==>서브쿼리의 행이 존재하는지만 체크
            그래서 관습적으로 SELECT 'X' 를 주로 사용
             
EXISTS (서브쿼리)
1.아래쿼리에서 서브쿼리는 단독으로 실행가능하다
이유는?서브쿼리의 실행결과에 메인쿼리에 행값과 관계없이 항상 실행되고
반환되는 행의 수는 1개의 행이다
SELECT *
FROM emp
WHERE EXISTS(SELECT 'x'
             FROM dual)

일반적으로 EXISTS 연산자는 상호연관 서브쿼리에서 실행된다
1.사원 정보를 조회하는데
2.WHERE m.empno = e.mgr 조건을 만족하는 사원만 조회

==>매니저 정보가 존재하는 사원조회 13건
SELECT *
FROM emp e
WHERE EXISTS(SELECT 'X'
             FROM emp m
             WHERE m.empno = e.mgr)
==>서브쿼리가 확인자로 사용되었다
    비상호 연관의 경우 서브쿼리가 먼저 실행될수도 있다
        ==>서브쿼리가 제공자로 사용되었다

        
연산자:행이 몇개가 필요한 연산자인지
피연산자1 + 피연산자2
피연산자1++
? 3항 연산자 ==> IF

IN 연산자:
컬럼 IN(서브쿼리,값을 나열하거나)
매니저가 존재하는 사원정보 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL
실습 9번
SELECT *
FROM product p
WHERE EXISTS(SELECT 'x'
             FROM cycle c
             WHERE cid = 1
             AND c.pid = p.pid)
SELECT *
FROM product p
WHERE pid IN(SELECT pid
             FROM cycle c
             WHERE c.cid = 1)
실습 10번
SELECT *
FROM product p
WHERE NOT EXISTS(SELECT 'x'
             FROM cycle c
             WHERE cid = 1
             AND c.pid = p.pid)

집합 연산
SQL에서 데이터를 확장하는 방법             
가로 확장(컬럼을 확장):JOIN
세로 확장(행을 확장):집합 연산
                   집합연산을 하기 위해서는 연산에 참여하는 두개의 SQL(집합)이
                   동일 한 컬럼 개수와 타입가져야한다

수학시간에 배운 집합의 개념과 동일
집합의 특징:순서가 없다(1,2),(2,1) 동일한 집합
          요소의 중복이 없다(1,1,3) ==> {1,3}
          
SQL에서 제공하는 집합 연산자          
UNION 합집합
합집합:두개의 집합을 하나로 합칠때 두집합 속하는 요소는 한번만 표현된다
    (1,2,3) U (1,4,5) ==>(1,1,2,3,4,5) =>(1,2,3,4,5)
INTERSECT 교집합
교집합:두개의 집합에서 서로 중복되는 별도의 집합으로 생성
    (1,2,3) 교집합(1,4,5)==>(1,1)==>(1)
MINUS 차집합
차집합:앞에서 선언된 집합의 요소중 뒤에 선언된 집합의 요소를 제거하고 남은 요소로 새로운 집합을 생성
    (1,2,3) - (1,4,1) = (2,3)
교환법칙:항의 위치를 수정해도 결과가 동일한 연산
        a+b,b+a
차집합의 경우 교환법칙이 성립되지않는다
    a-b != b-a
    (1,2,3) - (1,4,5) = (2,3)
    (1,4,5) - (1,2,3) = (4,5)

UNION 연산자
집합연산을 하려는 두개의 집합이 동일하기때문에 합집합을 하면 중복을 허용하지않기 때문에
7566,7698 사변을 갖는 사원이 한번씩만 조회가 된다
SELECT empno,ename
FROM emp
WHERE empno IN(7566,7698)

UNION

SELECT empno,ename
FROM emp
WHERE empno IN(7566,7698);

UNION ALL:중복을 허용한다,위의 집합과 아래 집합을 단순히 합친다
SELECT empno,ename
FROM emp
WHERE empno IN(7566,7698)

UNION ALL

SELECT empno,ename
FROM emp
WHERE empno IN(7566,7698);

INTERSECT:교집합,두집합에서 공통된 부분만 새로운 집합으로 생성
SELECT empno,ename
FROM emp
WHERE empno IN(7369,7566,7499)
INTERSECT
SELECT empno,ename
FROM emp
WHERE empno IN(7566,7698);

집합연산 특징
1.컬럼명이 동일하지않아도됨 (AS로 바꿔도 된다)
    단 조회결과는 첫번째 집합의 컬럼을 따른다
2.정렬이 필요한경우 마지막 집합 뒤에다 기술한다    
3.UNIOIN ALL을 제외한 경우 중복제거 작업이 들어간다

MINUS: 차집합,한쪽 집합에서 다른쪽 집합을 뺀것
SELECT empno ENO,ename
FROM emp
WHERE empno IN(7369,7566,7499)
MINUS
SELECT empno,ename
FROM emp
WHERE empno IN(7566,7698)
ORDER BY ename;



UNION과 UNION ALL의 차이
UNION:수학의 집합연산과 동일
        위의 집합과 아래 집합에서중복되는 데이터를 한번 제거
        중복되는 데이터를 찾아야함 ==>연산이 필요,속도가 느림
UNION ALL:합집합의 정의와 다르게 중복을 허용
          위의 집합과 아래 집합의 행을 붙이는행위만 실시
          중복을 찾는 과정이 없기때문에 속도면에서 빨라
          
개발자가 두 집합의 중복이 없다는것을 알고 잇으면 UNION보다는 UNION ALL 을 사용하는게 좋다

DML-INSERT:테이블에 데이터를 입력하는 SQL문장
1.어떤 테이블에 데이터를 입력할지 테이블을 정한다
2.해당테이블의 어떤컬럼에 어떤값을 입력할지 정한다
문법
INSERT INTO 테이블(컬럼1,컬럼2....)
VALUES(데이터값1,데이터값2.....);

예제
dept 테이블에 99번 부서번호를 갖는 ddit를 부서명으로 daejeon지역에 위치하는 부서를 등록
INSERT INTO dept(deptno,dname,loc)
VALUES(99,'ddit','daejeon');

컬럼명을 나열할때 테이블 정의에 따른 컬럼순서를 반드시 따를 필요는 없다
다만 VALUES 절에 기술한 해당 컬럼에 입력할값의 위치만 지키면 된다
INSERT INTO dept(dname,loc,deptno)
VALUES('ddit','daejeon',99);

만약 테이블의 모든 컬럼에 대해 값을 입력하고자 할 경우는 컬럼을 나열하지 않아도 된다
단 values 절에 값을 입력할 기술할 순서는 테이블에 정의된 컬럼의 순서와 동일해야한다

테이블 컬럼 정의:DESC 테이블명
DESC dept; -순서 deptno,dname,loc
INSERT INTO dept 
VALUES(98,'ddit','대전')

모든 컬럼에 값을 입력하지않을수도 있다
단 해당 컬럼이 NOT NULL 제약조건이 걸려있는 경우는 컬럼에 반드시 값이 들어가야한다
컬럼에 NOT NULL 제약조건 적용여부는 DESC 테이블; 를 통해 확인가능
SELECT *
FROM dept

DESC emp;
실패한 쿼리 empno는 NOT NULL 제야조건이 존재하기때문에 반드시 값을 입력해야한다
INSERT INTO emp(ename,job)
VALUES('brown','MANAGER')

data 타입에 대한 insert
emp 테이블에 sally 사원을 오늘 날짜로 입사할때 신규 데이터 입력,job=RANGER,empno=9998

INSERT INTO emp(hiredate,job,empno) VALUES(SYSDATE,'RANGER',9998);
INSERT INTO emp(hiredate,job,empno,ename) VALUES(TO_DATE('2020/07/09','YYYY/MM/DD'),'RANGER',9997,'moon');

SELECT *
FROM emp

위에서 실행한 INSERT 구문들이 모두 취소
ROLLBACK;

SELECT 쿼리 결과를 테이블 입력
SELECT 쿼리 결과는 여러건의 행이 될수도 있다
여러건의 데이터를 하나의 INSERT 구문을 통해서 입력
문법
INSERT INTO 테이블명{컬럼1,컬럼2....}
SELECT 컬럼1,컬럼2
FROM ...

처리속도가 빠르다
INSERT INTO emp(hiredate,job,empno,ename)
SELECT SYSDATE,'RANGER',9998,null
FROM dual
UNION ALL
SELECT TO_DATE('2020/07/09','YYYY/MM/DD'),'RANGER',9997,'moon'
FROM dual;


UPDATE:테이블에 존재하는 데이터를 수정하는것
1.어떤 테이블을 업데이트 할건지?
2.어떤 컬럼을 어떤값으로 업데이트 할건지
3.어떤 행에 대해서 업데이트 할건지(SELECT 쿼리의 WHERE 절과 동일)
문법
UPDATE 테이블명 
SET 컬럼명1= 변경할 값1,
    컬럼명2= 변경할 값2
WHERE 변경할 행을 제한할 조건;

deptno가 90,dname이 ddit loc가 대전인 데이터를 dept 테이블에 입력하는 쿼리 작성
INSERT INTO dept(deptno,dname,loc)
VALUES(90,'ddit','대전');

부서번호90번에 ddit==>대덕ddit
대전==>daejeon으로 수정

UPDATE dept
SET dname='대덕ddit',
    loc = 'daejeon'
WHERE deptno = 90;    

업데이트 쿼리를 작성할때 주의점
1.WHERE절이 있는지 없는지 확인
  WHERE절이 없다는건 모든 행에대해서 업데이트를 행한다는 의미
2.UPDATE 하기전에 기술한 WHERE 절을 SELECT절에 적용하여 업데이트 대상
  데이터를 눈으로 확인하고 실행

