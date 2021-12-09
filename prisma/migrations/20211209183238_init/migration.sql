-- CreateTable
CREATE TABLE "organization" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "subscription_id" INTEGER NOT NULL,
    "domain_restricted" BOOLEAN NOT NULL,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "role_type" INTEGER NOT NULL,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "annual_price" DOUBLE PRECISION NOT NULL,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "email_domain" (
    "id" SERIAL NOT NULL,
    "domain" TEXT NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "email_domain_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_user" (
    "id" SERIAL NOT NULL,
    "google_profile_id" INTEGER NOT NULL,
    "role_id" INTEGER,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "_user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "google_profile" (
    "id" SERIAL NOT NULL,
    "sub" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "given_name" TEXT NOT NULL,
    "family_name" TEXT NOT NULL,
    "picture" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "email_verified" BOOLEAN NOT NULL,
    "locale" TEXT NOT NULL,
    "hd" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "google_profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "board" (
    "id" SERIAL NOT NULL,
    "board_type" INTEGER NOT NULL,
    "user_id" INTEGER,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "board_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "position" (
    "id" SERIAL NOT NULL,
    "position" INTEGER NOT NULL,
    "board_id" INTEGER NOT NULL,
    "channel_id" INTEGER NOT NULL,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "channel" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "channel_type" INTEGER NOT NULL,
    "image" TEXT,
    "description" TEXT,
    "emoji" TEXT,
    "user_id" INTEGER,
    "organization_id" INTEGER,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "channel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invitation" (
    "id" SERIAL NOT NULL,
    "slug" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "invitee_email" TEXT NOT NULL,
    "invitee_name" TEXT,
    "organization_id" INTEGER NOT NULL,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invitation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tag" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "user_id" INTEGER,
    "date_created" TIMESTAMP(3) NOT NULL,
    "last_modified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_ChannelToTag" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "organization_slug_key" ON "organization"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "role_user_id_key" ON "role"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "email_domain_domain_key" ON "email_domain"("domain");

-- CreateIndex
CREATE UNIQUE INDEX "_user_google_profile_id_key" ON "_user"("google_profile_id");

-- CreateIndex
CREATE UNIQUE INDEX "google_profile_email_key" ON "google_profile"("email");

-- CreateIndex
CREATE UNIQUE INDEX "channel_url_key" ON "channel"("url");

-- CreateIndex
CREATE UNIQUE INDEX "invitation_slug_key" ON "invitation"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "_ChannelToTag_AB_unique" ON "_ChannelToTag"("A", "B");

-- CreateIndex
CREATE INDEX "_ChannelToTag_B_index" ON "_ChannelToTag"("B");

-- AddForeignKey
ALTER TABLE "organization" ADD CONSTRAINT "organization_subscription_id_fkey" FOREIGN KEY ("subscription_id") REFERENCES "subscription"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role" ADD CONSTRAINT "role_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role" ADD CONSTRAINT "role_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "email_domain" ADD CONSTRAINT "email_domain_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_user" ADD CONSTRAINT "_user_google_profile_id_fkey" FOREIGN KEY ("google_profile_id") REFERENCES "google_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "board" ADD CONSTRAINT "board_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position" ADD CONSTRAINT "position_board_id_fkey" FOREIGN KEY ("board_id") REFERENCES "board"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position" ADD CONSTRAINT "position_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "channel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channel" ADD CONSTRAINT "channel_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "channel" ADD CONSTRAINT "channel_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invitation" ADD CONSTRAINT "invitation_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invitation" ADD CONSTRAINT "invitation_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tag" ADD CONSTRAINT "tag_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChannelToTag" ADD FOREIGN KEY ("A") REFERENCES "channel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChannelToTag" ADD FOREIGN KEY ("B") REFERENCES "tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
