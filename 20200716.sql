개발자가 sql을 dbms에 요청을 하더라도
1.오라클 서버가 항상 최적의 실행계획을 선택할수는 없음
(응답성이 중요하기때문:OLTP -온라인 트랜잭션 프로세싱)

전체 처리 시간이 중요:OLAP -온라인 
                         은행이자 ==>실행계획 세우는 30분 이상이 소요되기도 함
2.항상 실행계획을 세우지 않음
만약에 동일한 SQL이 이미 실행된적 있으면 해당 SQL의 실행계획을 새롭게 세우지 않고
Shared poop(메모리)에 존재하는 실행계획을 재사용

동일한 sql:문자가 완벽하게 동일한 SQL
          SQL의 실행 결과가 같다고 해서 동일한 SQL이 아님
          대소문자를 가리고 공백도 문자로 취급
          
EX:SELECT * FROM emp;
   select * FROM emp;
   두개의 sql의 서로 다른 sql로 인식
   
SELECT /*plan_test */   *
FROM emp
WHERE empno = :empno;

DCL:DATA CONTROL LANGUAGE -시스템 권한 또는 객체 권한을 부여 / 회수
부여
GRANT 권한명 | 롤명 TO 사용자;
회수
REVOKE 권한명 | 롤명 FROM 사용자;

data dictionary
오라클 서버가 사용자 정보를 관리하기위해 저장한 데이터를 볼수있는 view

CATEGORY(접두어)
USER:해당 사용자가 소유한 객체 조회
ALL:해당 사용자가 소유한 객체+권한을 부여받은 객체조회
DBA:데이터베이스에 설치된 모든 객체 (DBA 권한이 잇는 사용자만 가능 = SYSTEM)
v$:성능,모니터와 관련된 특수 view

SELECT *
FROM dictionary

SELECT *
FROM user_tables;

SELECT *
FROM all_tables;

SELECT *
FROM dba_tables;






