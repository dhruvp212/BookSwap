<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" EnableEventValidation="false" CodeFile="~/Client/SwapBook.aspx.cs" Inherits="Client_SwapBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
    <style>
        .book-card { transition: transform 0.2s, box-shadow 0.2s; border: none; border-radius: 12px; overflow: hidden; }
        .book-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
        .card-img-top { height: 250px; object-fit: cover; }
        .badge-price { position: absolute; top: 10px; right: 10px; font-size: 14px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        .library-name { font-size: 13px; color: #6c757d; font-weight: 600; display: block; margin-bottom: 8px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
    <div class="container my-5">
        <div class="text-center mb-5">
            <h2 class="fw-bold" style="color: #0f3460;">Library Collection</h2>
            <p class="text-muted">Browse and securely borrow premium books directly from verified local libraries.</p>
        </div>

        <div class="row g-4">
            <asp:Repeater ID="rptBooklist" runat="server">
                <ItemTemplate>
                    <div class="col-md-3 col-sm-6">
                        <div class="card book-card shadow-sm h-100 position-relative">
                            
                            <!-- Price Badge -->
                            <span class="badge bg-warning text-dark badge-price px-3 py-2 rounded-pill">
                                <%# Convert.ToDecimal(Eval("RentPriceperDay")) == 0 ? "Free" : string.Format("{0:C}/Day", Eval("RentPriceperDay")) %>
                            </span>

                            <img src='<%# ResolveUrl(Eval("Photo1").ToString()) %>' class="card-img-top" alt="Book Cover" onerror="this.src='../assets/images/placeholder-book.png';">
                            
                            <div class="card-body d-flex flex-column">
                                <span class="library-name"><i class="ti ti-building-library"></i> <%# Eval("LibraryName") %></span>
                                <h5 class="card-title fw-bold text-dark"><%#Eval("BookTitle") %></h5>
                                <p class="card-text small mb-3 flex-grow-1">
                                    <strong>Author:</strong> <span class="text-muted"><%#Eval("Auther") %></span><br>
                                    <strong>Category:</strong> <span class="text-muted"><%#Eval("Category") %></span><br>
                                    <strong>ISBN:</strong> <span class="text-muted"><%#Eval("INSBNO") %></span>
                                </p>
                                
                                <%# Convert.ToInt32(Eval("IsAvailable")) == 1 ? 
                                    "<a href='ProductDetail.aspx?id=" + Eval("BookId") + "' class='btn btn-primary w-100 mt-auto fw-bold' style='background:#e94560; border:none;'>View Details & Borrow</a>" : 
                                    "<button class='btn btn-secondary w-100 mt-auto fw-bold' disabled>Already Borrowed</button>" %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" runat="Server">
</asp:Content>

