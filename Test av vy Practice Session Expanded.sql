--- Test av vy
SELECT * FROM dbo.v_PracticeSessions_Expanded
WHERE UserId = '8F534638-6E25-4310-81CA-AB284F796E59' AND PracticeDate >= DATEADD(day,-30, CAST(GETDATE() AS date))
ORDER BY PracticeDate DESC;
