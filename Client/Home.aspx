<%@ Page Title="" Language="C#" MasterPageFile="~/Client/Client.master" AutoEventWireup="true" CodeFile="~/Client/Home.aspx.cs"Inherits="Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPage" Runat="Server">
    <!-- Hero Carousel -->
    <div id="heroCarousel" class="carousel slide carousel-fade mb-5" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active" aria-current="true"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner" style="border-radius: 30px;">
            <div class="carousel-item active" data-bs-interval="5000">
                <div class="hero-section glass-panel p-5 position-relative overflow-hidden">
                    <div class="row align-items-center position-relative" style="z-index: 2;">
                        <div class="col-lg-6 mb-4 mb-lg-0 text-start">
                            <div class="badge bg-accent text-dark px-3 py-2 rounded-pill mb-3 fw-bold">DISCOVER NEW WORLDS</div>
                            <h1 class="display-3 fw-bold mb-3"><span class="animate-color">Rediscover</span> the Joy of Reading</h1>
                            <p class="lead text-secondary mb-4">Join our community of book lovers. Swap your read books with neighbors or borrow from local library collections.</p>
                            <a href="SwapBook.aspx" class="btn btn-primary px-5 py-3 rounded-pill d-inline-flex align-items-center gap-2 shadow-lg">
                                <i data-lucide="search" class="size-5"></i> Browse Books
                            </a>
                        </div>
                        <div class="col-lg-6 text-center">
                            <img src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?q=80&w=1000&auto=format&fit=crop" 
                                 alt="Library" class="img-fluid rounded-4 shadow-lg animate-up" style="max-height: 450px; border: 8px solid var(--glass-bg);">
                        </div>
                    </div>
                </div>
            </div>
            <div class="carousel-item" data-bs-interval="5000">
                <div class="hero-section glass-panel p-5 position-relative overflow-hidden">
                    <div class="row align-items-center position-relative" style="z-index: 2;">
                        <div class="col-lg-6 mb-4 mb-lg-0 text-start">
                            <div class="badge bg-accent text-dark px-3 py-2 rounded-pill mb-3 fw-bold">COMMUNITY FIRST</div>
                            <h1 class="display-3 fw-bold mb-3"><span class="animate-color">Swap</span> & Connect Locally</h1>
                            <p class="lead text-secondary mb-4">Sharing is caring. Give your old books a new home and find your next favorite story right in your neighborhood.</p>
                            <a href="StudentReg.aspx" class="btn btn-primary px-5 py-3 rounded-pill d-inline-flex align-items-center gap-2 shadow-lg">
                                <i data-lucide="user-plus" class="size-5"></i> Join Community
                            </a>
                        </div>
                        <div class="col-lg-6 text-center">
                            <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?q=80&w=1000&auto=format&fit=crop" 
                                 alt="Bookshelf" class="img-fluid rounded-4 shadow-lg animate-up" style="max-height: 450px; border: 8px solid var(--glass-bg);">
                        </div>
                    </div>
                </div>
            </div>
            <div class="carousel-item" data-bs-interval="5000">
                <div class="hero-section glass-panel p-5 position-relative overflow-hidden">
                    <div class="row align-items-center position-relative" style="z-index: 2;">
                        <div class="col-lg-6 mb-4 mb-lg-0 text-start">
                            <div class="badge bg-accent text-dark px-3 py-2 rounded-pill mb-3 fw-bold">LIBRARY NETWORK</div>
                            <h1 class="display-3 fw-bold mb-3">Support Your <span class="animate-color">Local Library</span></h1>
                            <p class="lead text-secondary mb-4">Access a vast catalog of educational and fictional works from participating local libraries across the state.</p>
                            <a href="registerpage.aspx" class="btn btn-primary px-5 py-3 rounded-pill d-inline-flex align-items-center gap-2 shadow-lg">
                                <i data-lucide="library" class="size-5"></i> Register Library
                            </a>
                        </div>
                        <div class="col-lg-6 text-center">
                            <img src="https://images.unsplash.com/photo-1481627834876-b7833e8f5570?q=80&w=1000&auto=format&fit=crop" 
                                 alt="Library Hall" class="img-fluid rounded-4 shadow-lg animate-up" style="max-height: 450px; border: 8px solid var(--glass-bg);">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="p-3 glass-panel rounded-circle d-flex align-items-center justify-content-center" aria-hidden="true"><i data-lucide="chevron-left" class="text-primary"></i></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="p-3 glass-panel rounded-circle d-flex align-items-center justify-content-center" aria-hidden="true"><i data-lucide="chevron-right" class="text-primary"></i></span>
        </button>
    </div>

    <!-- Features Section -->
    <section id="features" class="py-5 mb-5">
        <div class="container">
            <div class="row g-4 text-center">
                <div class="col-md-4">
                    <div class="glass-panel p-5 h-100 feature-card">
                        <div class="p-4 rounded-circle bg-accent-light d-inline-block mb-4">
                            <i data-lucide="refresh-cw" class="size-10 text-primary"></i>
                        </div>
                        <h4 class="fw-bold mb-3">Book Exchange</h4>
                        <p class="text-secondary mb-0">Swap books with local readers and students to save money and promote reuse.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-panel p-5 h-100 feature-card">
                        <div class="p-4 rounded-circle bg-accent-light d-inline-block mb-4">
                            <i data-lucide="library" class="size-10 text-primary"></i>
                        </div>
                        <h4 class="fw-bold mb-3">Library Network</h4>
                        <p class="text-secondary mb-0">Find and borrow books from nearby public and community libraries.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-panel p-5 h-100 feature-card">
                        <div class="p-4 rounded-circle bg-accent-light d-inline-block mb-4">
                            <i data-lucide="users" class="size-10 text-primary"></i>
                        </div>
                        <h4 class="fw-bold mb-3">Community Connect</h4>
                        <p class="text-secondary mb-0">Build a network of book lovers in your city for sharing and recommendations.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

<!-- Books Section -->
<section id="books" class="py-5">
    <div class="container">
        <h2 class="text-center mb-5 fw-bold animate-color">Popular Book Categories</h2>
        <div class="row g-4">
            <div class="col-md-3">
                <div class="card glass-card">
                    <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=400&h=250" class="card-img-top" alt="Science" style="border-radius: 20px 20px 0 0;">
                    <div class="card-body">
                        <h5 class="card-title fw-bold">Science</h5>
                        <p class="card-text small text-secondary">Explore physics, chemistry, biology, and more.</p>
                        <a href="#" class="btn btn-primary btn-sm">View Books</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card glass-card">
                    <img src="https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=400&h=250" class="card-img-top" alt="Literature" style="border-radius: 20px 20px 0 0;">
                    <div class="card-body">
                        <h5 class="card-title fw-bold">Literature</h5>
                        <p class="card-text small text-secondary">Classic and modern literary works from around the world.</p>
                        <a href="#" class="btn btn-primary btn-sm">View Books</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card glass-card">
                    <img src="https://images.unsplash.com/photo-1528207776546-365bb710ee93?auto=format&fit=crop&w=400&h=250" class="card-img-top" alt="Children" style="border-radius: 20px 20px 0 0;">
                    <div class="card-body">
                        <h5 class="card-title fw-bold">Children's Books</h5>
                        <p class="card-text small text-secondary">Fun, engaging, and educational books for kids.</p>
                        <a href="#" class="btn btn-primary btn-sm">View Books</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card glass-card">
                    <img src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=400&h=250" class="card-img-top" alt="Technology" style="border-radius: 20px 20px 0 0;">
                    <div class="card-body">
                        <h5 class="card-title fw-bold">Technology</h5>
                        <p class="card-text small text-secondary">Learn programming, AI, robotics, and latest innovations.</p>
                        <a href="#" class="btn btn-primary btn-sm">View Books</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Contentjavascript" Runat="Server">
</asp:Content>

