where 절에서 사용가능한 연산자:LIKE
사용용도:문자의 일부분으로 검색을하고 싶을때 사용
    ex:ename컬럼의 값이 2로 시작하는 사원들을 조회
사용방법:컬럼 LIKE '패턴문자열'
마스킴 문자열:%:문자가 없거나 어떤문자든 여러개의 문져알
    'S%':S로 시작하는 모든 문자열 ==>SMART S로 시작함
    _:어떤 문자든 딱 하나의 문자를 의미
    'S_':S로시작하고 두번째 문자가 어떤문자든 하나의 문자가오는 2자리 문자열
    'S____':S로 시작하고 문자열의 길이가 5글자인 문자열
emp테이블에서 ename 컬럼의 값이 s로 시작하는 사원들만 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';
실습 ppt 87번
SELECT mem_id,mem_name
FROM member
WHERE mem_name LIKE '신%';
실습 ppt 88번
SELECT mem_id,mem_name
FROM member
WHERE mem_name LIKE '이%';

UPDATE member
set mem_name = '쁜이'
WHERE mem_id = 'b001';

UPDATE member 
set mem_name = '신이환'
where mem_id = 'c001';

null 비교:=연산자로 비교 불가 ==>IS
NULL을 = 비교하여 조회하면 안된다

comm 컬럼의 값이 null인 사원들만 조회
SELECT empno,ename,comm
FROM emp
WHERE comm is NULL;
NULL값에대한 비교는 =이 아니라 IS 연산자를 사용한다

comm 컬럼의 값이 null이 아닌 사원들만 조회
SELECT empno,ename,comm
FROM emp
WHERE comm is not null;

논리연산자:AND ,OR,NOT
AND:식 두개를 동시에 만족하면 참
일반적으로 AND 조건이 많이 붙으면 조회되는 행의수 줄어듬
OR:식 두개중에 하나라도 만족하면 참
EMP 테이블에서 MGR 컬럼값이 7698이면서 SAL 컬럼의 값이 1000보다 큰 사원 조회
2가지 조건 동시에 만족

SELECT *
FROM emp
WHERE mgr = 7698
AND sal >1000;

SELECT *
FROM emp
WHERE mgr =7698
OR sal >1000;

NOT:조건을 반대로 해석하는 부정형 연산
    NOT IN
    IS NOT NULL
emp 테이블에서 mgr가 7698,7639가 아닌 사원들을 조회
조건 수가 많아지면 IS NOT 경우 복잡해진다
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7639);

MGR 사번이 7698이 아니고 7839가 아니고 NULL이 아닌 직원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7639,NULL);
데이터가 나오지 않는이유는 
MGR가 (7698,7639,NULL)포함된다
MGR IN (7698,7639,NULL) ==> MGR = 7698 OR MGR = 7639 OR MGR = NULL
MGR NOT IN (7698,7639,NULL) ==> MGR != 7698 AND MGR != 7639 AND MGR != NULL
not in 할경우 다 만족해야되서 안나올수있다

SELECT *
FROM emp
WHERE mgr != 7698 AND mgr != 7639;
mgr 컬럼에 null값이 있을경우 비교 연산으로 null비교가 불가하기 때문에
null을 갖는 행은 무시가 된다
실습 PPT 94번
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
실습 PPT 95번
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
실습 PPT 96번
SELECT *
FROM emp
WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
실습 PPT 97번
SELECT *
FROM emp
WHERE deptno IN(20,30) AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
실습 PPT 98번
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');
실습 PPT 99번
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';
형변환:명시적,묵시적
실습 PPT 100번
EMPNO:7800~7899
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno BETWEEN 7800 AND 7899;
실습 101번
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno >= 7800 AND empno <= 7899;
실습 104번
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

정렬
RDBMS:집합적인 사상을 따른다
집합에는 순서가 없다(1,3,5) == (3,5,1)
집합에는 중복이 없다(1,3,5) == (3,5,1)

정렬 방법:ORDER BY 절을 통해 정렬 기준 컬럼을 명시
        컬럼뒤에 [ASC | DESC]을 기술하여 오름차순,내림차순을 지정할수있다
ORDER BY 컬럼
ORDER BY 별칭
ORDER BY SELECT 절에 나열된 컬럼의 인덱스 번호

SELECT *
FROM emp
ORDER BY ename ASC;

SELECT *
FROM emp
ORDER BY ename DESC;

SELECT *
FROM emp
ORDER BY ename DESC,mgr;
이름이 중복되는경우 mgr컬럼을씀
예시
SELECT empno,ename,sal,sal*12 as salary
FROM emp
ORDER BY salary;

SELECT 절에 기술된 컬럼순서(인덱스)로 정렬
SELECT empno,ename,sal,sal*12 as salary
FROM emp
ORDER BY 4;
단점:컬럼을 변경했을경우 결과 달라짐
실습 PPT 109번
SELECT *
FROM dept
ORDER BY DNAME;

SELECT *
FROM dept
ORDER BY LOC DESC;

실습 
SELECT *
FROM emp
WHERE COMM is not null
AND COMM > 0
ORDER BY COMM DESC,empno DESC;

