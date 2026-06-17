<%@ Page Title="Book Details" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="~/Client/ProductDetail.aspx.cs" Inherits="Client_ProductDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="Server">
  <style>
    body { background-color: #f8f9fa; }
    .image-box {
      width: 100%; height: 400px;
      display: flex; align-items: center; justify-content: center;
      background: #fff; border-radius: 12px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 15px; margin-bottom: 15px;
    }
    .image-box img { max-width: 100%; max-height: 100%; object-fit: contain; }
    .thumb-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
    .thumb-img {
      width: 100%; height: 80px; object-fit: cover; border-radius: 8px; cursor: pointer;
      border: 2px solid transparent; transition: 0.3s;
    }
    .thumb-img:hover { border-color: #e94560; opacity: 0.8; }
    .price { color: #e94560; font-size: 32px; font-weight: 800; }
    .detail-card { background: #fff; border-radius: 12px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
    .btn-borrow { background: #e94560; color: white; padding: 12px 20px; font-weight: bold; border-radius: 8px; border: none; width: 100%; }
    .btn-borrow:hover { background: #d0304a; color: white; }
  </style>
  <script>
      function changeMainImg(src) {
          if(src && src !== '') {
              document.getElementById('mainPhoto').src = src;
          }
      }
  </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" runat="Server">
<div class="container my-5">
  <asp:Label ID="lblMessage" runat="server" CssClass="d-block text-center mt-3 mb-4 fw-bold"></asp:Label>
  <div class="row g-5" id="bookDetailsContainer" runat="server">
    
    <!-- LEFT: IMAGE GALLERY -->
    <div class="col-md-5">
      <div class="image-box">
        <img id="mainPhoto" src="placeholder.png" alt="Book Cover" runat="server">
      </div>
      <div class="thumb-grid">
        <img id="thumb1" src="" class="thumb-img" runat="server" onclick="changeMainImg(this.src)" />
        <img id="thumb2" src="" class="thumb-img" runat="server" onclick="changeMainImg(this.src)" />
        <img id="thumb3" src="" class="thumb-img" runat="server" onclick="changeMainImg(this.src)" />
        <img id="thumb4" src="" class="thumb-img" runat="server" onclick="changeMainImg(this.src)" />
      </div>
    </div>

    <!-- RIGHT: DETAILS & BORROW FORM -->
    <div class="col-md-7">
      <div class="detail-card">
          <h2 class="fw-bold" style="color: #0f3460;"><asp:Literal ID="litTitle" runat="server"></asp:Literal></h2>
          <p class="text-muted fs-5 mb-4">by <strong class="text-dark"><asp:Literal ID="litAuthor" runat="server"></asp:Literal></strong></p>

          <div class="d-flex align-items-center mb-4 pb-4 border-bottom">
              <div class="price me-4"><asp:Literal ID="litPrice" runat="server"></asp:Literal> <span class="fs-6 text-muted fw-normal">/ day</span></div>
              <asp:Literal ID="litAvailability" runat="server"></asp:Literal>
          </div>

          <div class="row mb-4">
              <div class="col-6">
                  <p><i class="ti ti-bookmark text-primary"></i> <strong>Category:</strong> <asp:Literal ID="litCategory" runat="server"></asp:Literal></p>
                  <p><i class="ti ti-barcode text-primary"></i> <strong>ISBN:</strong> <asp:Literal ID="litISBN" runat="server"></asp:Literal></p>
              </div>
              <div class="col-6">
                  <p><i class="ti ti-school text-primary"></i> <strong>Education Level:</strong> <asp:Literal ID="litEducation" runat="server"></asp:Literal></p>
                  <p><i class="ti ti-building-library text-primary"></i> <strong>Provided By:</strong> <span class="text-primary fw-bold"><asp:Literal ID="litLibrary" runat="server"></asp:Literal></span></p>
              </div>
              <div class="col-12 mt-3 text-muted">
                  <strong>Description:</strong><br/>
                  <asp:Literal ID="litDescription" runat="server"></asp:Literal>
              </div>
          </div>

          <!-- BORROW FORM -->
          <div class="bg-light p-4 rounded mt-2 border" id="borrowForm" runat="server">
              <h5 class="fw-bold mb-3"><i class="ti ti-calendar-event"></i> Schedule Your Borrow</h5>
              <div class="row g-3">
                  <div class="col-md-6">
                      <label class="form-label fw-bold">Borrow Date (Today)</label>
                      <asp:TextBox ID="txtBorrowDate" runat="server" CssClass="form-control bg-white" ReadOnly="true"></asp:TextBox>
                  </div>
                  <div class="col-md-6">
                      <label class="form-label fw-bold text-danger">Expected Return Date *</label>
                      <asp:TextBox ID="txtReturnDate" runat="server" CssClass="form-control" TextMode="Date" required="true"></asp:TextBox>
                  </div>
                  <div class="col-12 mt-4">
                      <asp:HiddenField ID="hfLibraryId" runat="server" />
                      <asp:HiddenField ID="hfBookId" runat="server" />
                      <asp:Button ID="btnConfirmBorrow" runat="server" CssClass="btn-borrow" Text="Submit Borrow Request" OnClick="btnConfirmBorrow_Click" />
                  </div>
              </div>
          </div>
          
      </div>
    </div>
  </div>
</div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" runat="Server">
</asp:Content>

