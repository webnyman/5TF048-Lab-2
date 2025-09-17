SELECT TOP 3 SessionId FROM dbo.PracticeSessions ORDER BY SessionId;
SELECT TagId, Name FROM dbo.Tag;

-- Lägg till taggar till övningssessioner
INSERT INTO dbo.PracticeSessionTag (SessionId, TagId) VALUES
(5, 1), -- Teknik
(1, 2), -- Etyder
(1, 3), -- Skalor
(2, 1), -- Konsertförberedelse
(2, 2), -- Teknik
(3, 5), -- Uppvärmning
(4, 1); -- Teknik
