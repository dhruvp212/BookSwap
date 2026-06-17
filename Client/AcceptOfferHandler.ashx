<%@ WebHandler Language="C#" Class="AcceptOfferHandler" %>

using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.SessionState;

/// <summary>
/// Accepts a book-offer deal and locks it when both parties agree.
/// GET  ?swapId=8&offeredSwapId=9&action=status  → returns current deal state
/// GET  ?swapId=8&offeredSwapId=9&action=accept  → current user accepts; locks if both accepted
/// </summary>
public class AcceptOfferHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext ctx)
    {
        ctx.Response.ContentType  = "application/json";
        ctx.Response.CacheControl = "no-cache";

        // ── Auth check ──────────────────────────────────────────────────────
        if (ctx.Session == null || ctx.Session["User"] == null)
        {
            ctx.Response.Write("{\"error\":\"Not logged in\"}");
            return;
        }
        int myUserId = Convert.ToInt32(ctx.Session["User"].ToString());

        // ── Parse params ────────────────────────────────────────────────────
        int swapId, offeredSwapId;
        if (!int.TryParse(ctx.Request.QueryString["swapId"],       out swapId)       || swapId       <= 0 ||
            !int.TryParse(ctx.Request.QueryString["offeredSwapId"], out offeredSwapId) || offeredSwapId <= 0)
        {
            ctx.Response.Write("{\"error\":\"Invalid parameters\"}");
            return;
        }
        string action = (ctx.Request.QueryString["action"] ?? "status").ToLower();

        string conn = ConfigurationManager.ConnectionStrings["BookswapConnectionString1"].ConnectionString;

        try
        {
            using (var con = new SqlConnection(conn))
            {
                con.Open();

                // ── Get deal record ─────────────────────────────────────────
                int  dealId = 0;
                bool reqAcc = false, ownerAcc = false, isLocked = false;
                int  ownerId = 0, requesterId = 0;

                using (var cmd = new SqlCommand(
                    "SELECT DealId, RequesterAccepted, OwnerAccepted, IsLocked, OwnerId, RequesterId " +
                    "FROM SwapDealTbl WHERE SwapRequestId=@sid AND OfferedSwapId=@osid", con))
                {
                    cmd.Parameters.AddWithValue("@sid",  swapId);
                    cmd.Parameters.AddWithValue("@osid", offeredSwapId);
                    using (var rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            dealId      = Convert.ToInt32(rdr["DealId"]);
                            reqAcc      = Convert.ToBoolean(rdr["RequesterAccepted"]);
                            ownerAcc    = Convert.ToBoolean(rdr["OwnerAccepted"]);
                            isLocked    = Convert.ToBoolean(rdr["IsLocked"]);
                            ownerId     = Convert.ToInt32(rdr["OwnerId"]);
                            requesterId = Convert.ToInt32(rdr["RequesterId"]);
                        }
                    }
                }

                if (dealId == 0)
                {
                    // No deal record yet
                    ctx.Response.Write("{\"dealStatus\":\"no_deal\",\"isLocked\":false}");
                    return;
                }

                // ── Status-only request ─────────────────────────────────────
                if (action == "status")
                {
                    string ds = isLocked ? "locked" : reqAcc && ownerAcc ? "locked" : reqAcc ? "requester_accepted" : "pending";
                    ctx.Response.Write(
                        "{\"dealStatus\":\"" + ds + "\",\"isLocked\":" + (isLocked?"true":"false") +
                        ",\"ownerAccepted\":"     + (ownerAcc ?"true":"false") +
                        ",\"requesterAccepted\":" + (reqAcc   ?"true":"false") + "}");
                    return;
                }

                // ── Accept action ───────────────────────────────────────────
                if (action == "accept")
                {
                    if (isLocked)
                    {
                        ctx.Response.Write("{\"dealStatus\":\"locked\",\"isLocked\":true}");
                        return;
                    }

                    bool isOwner     = myUserId == ownerId;
                    bool isRequester = myUserId == requesterId;

                    if (!isOwner && !isRequester)
                    {
                        ctx.Response.Write("{\"error\":\"Not a party to this deal\"}");
                        return;
                    }

                    // Mark this user's acceptance
                    if (isOwner)    ownerAcc   = true;
                    if (isRequester) reqAcc    = true;

                    bool justLocked = reqAcc && ownerAcc;

                    // Update deal record
                    using (var upd = new SqlCommand(
                        "UPDATE SwapDealTbl SET " +
                        "  RequesterAccepted=@ra, OwnerAccepted=@oa, " +
                        "  IsLocked=@locked, LockedAt=CASE WHEN @locked=1 THEN GETDATE() ELSE LockedAt END " +
                        "WHERE DealId=@did", con))
                    {
                        upd.Parameters.AddWithValue("@ra",    reqAcc   ? 1 : 0);
                        upd.Parameters.AddWithValue("@oa",    ownerAcc ? 1 : 0);
                        upd.Parameters.AddWithValue("@locked", justLocked ? 1 : 0);
                        upd.Parameters.AddWithValue("@did",  dealId);
                        upd.ExecuteNonQuery();
                    }

                    // ── When BOTH accepted: lock both books ─────────────────
                    if (justLocked)
                    {
                        // Mark BOTH swap requests as Locked (status = 3)
                        using (var lockCmd = new SqlCommand(
                            "UPDATE SwapRequestTbl SET SwapStatus=3 " +
                            "WHERE SwapRequestId=@sid1 OR SwapRequestId=@sid2", con))
                        {
                            lockCmd.Parameters.AddWithValue("@sid1", swapId);
                            lockCmd.Parameters.AddWithValue("@sid2", offeredSwapId);
                            lockCmd.ExecuteNonQuery();
                        }

                        // Insert system message so both sides' polling picks it up
                        // Format: [DEAL_LOCKED:offeredSwapId|||targetSwapId]
                        string sysMsg = "[DEAL_LOCKED:" + offeredSwapId + "|||" + swapId + "]";
                        using (var msgCmd = new SqlCommand(
                            "INSERT INTO SwapChatTbl (SwapRequestId, SenderId, Message, SentAt) " +
                            "VALUES (@sid, @uid, @msg, GETDATE())", con))
                        {
                            msgCmd.Parameters.AddWithValue("@sid", swapId);
                            msgCmd.Parameters.AddWithValue("@uid", myUserId);
                            msgCmd.Parameters.AddWithValue("@msg", sysMsg);
                            msgCmd.ExecuteNonQuery();
                        }
                    }

                    string newStatus = justLocked ? "locked" : (isOwner ? "owner_accepted" : "requester_accepted");
                    ctx.Response.Write(
                        "{\"dealStatus\":\"" + newStatus + "\",\"isLocked\":" + (justLocked?"true":"false") + "}");
                    return;
                }

                ctx.Response.Write("{\"error\":\"Unknown action\"}");
            }
        }
        catch (Exception ex)
        {
            ctx.Response.StatusCode = 500;
            ctx.Response.Write("{\"error\":\"" + ex.Message.Replace("\"","'") + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }
}
