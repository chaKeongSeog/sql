OUTER JOIN <> INNER JOIN
INNER JOIN:조인 조건을 만족하는 데이터만 조회
OUTER JOIN:조인 조건을 만족하지않더라도 기준이 되는 테이블 쪽의데이터(컬럼)은 조회가 되도록하는 조인 방식

OUTER JOIN
    LEFR OUTER JOIN:조인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
    RIGHT OUTER JOIN:조인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 OUTER JOIN시행
    FULL OUTER JOIN:LEFT OUTER +RIGHT JOIN -중복되는것 제외

ANSI-SQL
FROM 테이블:LEFT OUTER JOIN 테이블2 ON(조인조건)

ORACLE-SQL:데이터가 없는데 나와야하는 테이블의 컬럼 ==>반대쪽 테이블에 +를 붙임(데이터가 없는쪽)
FROM 테이블1,테이블2
WHERE 테이블1.컬럼 = 테이블2.컬럼(+)

ANSI-SQL OUTER
SELECT e.empno,e.ename,m.empno,m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT *
FROM emp



SELECT e.empno,e.ename,m.empno,m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)

ORACLE-SQL OUTER
SELECT e.empno,e.ename,m.empno,m.ename
FROM emp e,emp m
WHERE e.mgr = m.empno(+);

OUTER JOIN시 조인조건(ON 절에 기술)과 일반 조건 (WHERE 절에 기술)적용시 주의 사항
1.OUTER JOIN을 사용하는데 WHERE 절에 별도의 다른 조건을 기술할 경우 원하는 결과가 안나올수 있다
==>OUTER JOIN의 결과가 무시
SELECT e.empno,e.ename,m.empno,m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno = 10)

SELECT *
FROM emp

SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno=10);

ORACLE-SQL
SELECT e.empno,e.ename,m.empno,m.ename
FROM emp e,emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10




SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e ,emp m
WHERE e.mgr = m.empno(+) 
AND m.deptno(+)=10


WHERE 절에 기술한 경우(OUTER JOIN을 적용하지않은 쿼리)
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE m.deptno = 10

SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE  m.deptno=10    

ORACLE-SQL
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e ,emp m
WHERE e.mgr = m.empno(+) 
AND m.deptno = 10

RIGHT OUTER JOIN:기준 테이블이 오른쪽
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)

SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno) ==>LEFT OUTER JOIN은 14건

SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno) ==>RIGHT OUTER JOIN은 21건

FULL OUTER JOIN:LEFT OUTER + RIGHT JOIN - 중복 제거
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno); ==>RIGHT OUTER JOIN은 22건

ORACLE-SQL에서는 FULL OUTER를 적용하지않음


FULL OUTER 검증
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
UNION
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
MINUS
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
UNION
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
INTERSECT
SELECT e.empno,e.ename,m.empno,m.ename,m.deptno
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);

실습 248번~ 과제


순위,시도,시군구 ,버거 도시발전지수(소수점 두자리)
정렬은 순위가 놓은 행이 가장 먼저 나오도록
발전지수 = (KFC+버거킹+맥도날드) / 롯데리아
1.서울특별시,강남구,5.32
2.서울특별시,서초구,5.13
SELECT *
FROM fastfood

SELECT sido,sigungu,ROUND(SUM(NVL(DECODE(gb,'KFC',1),0))+SUM(NVL(DECODE(gb,'버거킹',1),0))+SUM(NVL(DECODE(gb,'맥도날드',1),0))/
                    SUM(NVL(DECODE(gb,'롯데리아',1),1)),2)
FROM fastfood
WHERE gb IN('KFC','버거킹','맥도날드','롯데리아')

GROUP BY sido,sigungu







SELECT sido,sigungu,ROUND(COUNT(*)/DECODE(sigungu,'강남구',7,'서초구',4,'DDIT'),2) cnt
FROM fastfood
WHERE sido = '서울특별시'
AND (sigungu = '강남구')
AND (gb = 'KFC' OR gb = '버거킹' OR gb = '맥도날드')
OR sido = '서울특별시'
AND (sigungu = '서초구')
AND (gb = 'KFC' OR gb = '버거킹' OR gb = '맥도날드')
GROUP BY sido,sigungu
ORDER BY cnt DESC

정답 쿼리 복붙해
SELECT sido, sigungu, 
       ROUND((NVL(SUM(DECODE(gb, 'KFC', 1)), 0) + 
           NVL(SUM(DECODE(gb, '맥도날드', 1)), 0) +
           NVL(SUM(DECODE(gb, '버거킹', 1)), 0)) /
           NVL(SUM(DECODE(gb, '롯데리아', 1)), 1), 2) SCORE
FROM fastfood
WHERE gb IN ('KFC', '맥도날드', '버거킹', '롯데리아')
GROUP BY sido, sigungu
ORDER BY SCORE DESC;


1,2,3번 미완료

실습 4번
SELECT DECODE(product.pnm,'윌',200,
                          '쿠퍼스',300,
                          cycle.pid) pid,product.pnm,NVL(cycle.cid,1) cid,NVL(cycle.day,0) day,NVL(cycle.cnt,0) cnt
FROM cycle,product
WHERE cycle.pid (+)= product.pid
AND cycle.cid(+) = 1
실습 5번
SELECT DECODE(product.pnm,'윌',200,
                          '쿠퍼스',300,
                          cycle.pid) pid,product.pnm,NVL(cycle.cid,1) cid,NVL(cycle.day,0) day,NVL(cycle.cnt,0) cnt,
                          NVL(customer.cnm,'brown') cnm
FROM cycle,product,customer
WHERE cycle.pid(+) = product.pid
AND CUSTOMER.CID(+) = cycle.cid
AND cycle.cid(+) = 1



