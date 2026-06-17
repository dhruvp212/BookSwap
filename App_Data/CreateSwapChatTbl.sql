-- ══════════════════════════════════════════════════════════════
-- Run this SQL in your database (Bookswap.mdf) to create the
-- chat table used by BookExchange.aspx
-- ══════════════════════════════════════════════════════════════

CREATE TABLE [dbo].[SwapChatTbl] (
    [MessageId]      INT           IDENTITY (1, 1) NOT NULL,
    [SwapRequestId]  INT           NOT NULL,
    [SenderId]       INT           NOT NULL,
    [Message]        NVARCHAR(MAX) NOT NULL,
    [SentAt]         DATETIME      NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY CLUSTERED ([MessageId] ASC),
    CONSTRAINT [FK_SwapChat_SwapRequest]
        FOREIGN KEY ([SwapRequestId]) REFERENCES [dbo].[SwapRequestTbl] ([SwapRequestId]) ON DELETE CASCADE,
    CONSTRAINT [FK_SwapChat_User]
        FOREIGN KEY ([SenderId]) REFERENCES [dbo].[UserTbl] ([UserID])
);

-- Index for fast message loading per swap request
CREATE NONCLUSTERED INDEX [IX_SwapChatTbl_SwapRequestId]
    ON [dbo].[SwapChatTbl] ([SwapRequestId] ASC, [SentAt] ASC);
